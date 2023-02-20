import asyncdispatch,os,osproc,sugar,strutils
import config
import gemini
import simpleargs


var p: ParseSchema
p.initParser("Nemini - A simple Gemini server"):
  p.addOption(long="--config", help="path to config file")#, default="/etc/nemini/nemini.toml")

var opts = p.parseOptions()
let nemini = getNeminiConfig(opts["config"])

proc getPage(s: Site, path: string): string =
  const extensions = [".gemini", ".gmi", ".gmni"]
  var p = path
  if path == "" or path == "/":
    p = s.index
  let page = s.root_dir / p
  for ext in extensions:
    # If the given url already has an extension
    if ext in page:
      return readFile(page)
    # otherwise check it's a valid one
    let pe = page & ext
    if fileExists(pe):
      return readFile(pe)

  # Removed for security - could potentially open any file on file system
  #if fileExists(page):
  #  return readFile(page)
  return ""

proc createCerts(l: Listener): bool =
  let site = l.sites[0]
  echo "Creating certificates for ", site.name
  let cmd = "openssl req -new -newkey rsa:4096 -days 365 -subj \"/C=US/ST=Denial/L=Springfield/O=Dis/CN=" & site.base_url & "\" -nodes -x509 -keyout " & l.private_key & " -out " & l.fullchain
  let output = execCmd(cmd)
  return output == 0

proc hasCerts(l: Listener): bool =
  if fileExists(l.fullchain) and fileExists(l.private_key):
    return true
  else:
    return createCerts(l)
  return false

proc findSite(url: string): Site =
  # TODO probably could do this better, ideally passing the listener into the handle procedure may make this a little nicer
  let sites = collect:
    for l in nemini.listeners:
      for s in l.sites:
        if s.base_url == url or s.aliases.contains(url):
          s
  return sites[0]

proc handle(req: AsyncRequest) {.async.} =
  try:
    # TODO go and find the site - not ideal, need to work out how to send the site the callback
    let site = findSite(req.url.hostname)
    # TODO if a file exists in the root directory use it, if not show an error
    let page = site.getPage(req.url.path)
    if page != "":
      echo "Found : ", req.url.hostname / req.url.path
      await req.respond(Success, "text/gemini", page)
    else:
      # TODO probably generate some better errors here
      echo "NotFound : ", req.url.path
      await req.respond(NotFound, "text/gemini", "# Page Not Found!")
  except:
    echo "ERROR: " & getCurrentExceptionMsg()
    await req.respond(ERROR, "text/gemini", "# Server Error")


when isMainModule:
  if len(nemini.listeners) > 0:
    echo "Starting Nemini..."
    for l in nemini.listeners:
      echo "Starting listener on port : ", l.port
      if l.hasCerts():
        var server = newAsyncGeminiServer(certFile = l.fullchain, keyFile = l.private_key)
        # TODO send the site into the handle callback for less work finding the site later
        asyncCheck server.serve(Port(l.port), handle)
    runForever()
