import asyncdispatch,os,sugar,strutils
import config
import certificates
import gemini
import simpleargs

proc parseArgs(): ParsedValues =
  var p: ParseSchema
  p.initParser("Nemini - A simple Gemini server"):
    p.addOption(long="--config", help="path to config file")#, default="/etc/nemini/nemini.toml")
    p.addFlag("-v", "--version", help="shows the current nemini version")#, default="/etc/nemini/nemini.toml")
    let opts = p.parseOptions()
    if opts.isSet("v") or opts.isSet("version"):
      echo "Nemini Version : ", newNemini().version
      quit(0)
    return opts

let opts = parseArgs()
let nemini = getNeminiConfig(opts["config"])

proc checkStatusCodes(content: string): (int, string) =
  if content == "":
    # Temporary failure
    return (51,content)
  case content[0]:
    of '3':
      let code = content[0..1].parseInt
      # Redirect - 30 == temporary, 31 == permanent
      return (code,content[3..^2])
    else:
      # There's content, return it
      return (20,content)

proc addHeaderAndFooter(content: var string, site: Site): string =
  let header = site.root_dir / "header.gemini"
  let footer = site.root_dir / "footer.gemini"
  if fileExists(header):
    content = readFile(header) & content
  if fileExists(footer):
    content &= "\r\n"
    content = content & readFile(footer)
  return content

proc getContent(s: Site, path: string): string =
  const extensions = [".gemini", ".gmi", ".gmni"]
  var p = path
  if path == "" or path == "/":
    p = s.index
  let page = s.root_dir / p
  var content = ""
  for ext in extensions:
    # If the given url already has an extension
    if ext in page:
      content &= readFile(page)
    # otherwise check it's a valid one
    let pe = page & ext
    if fileExists(pe):
      content &= readFile(pe)
    # if still nothing, check to see if there's an 
    # _index/.ge?m(in)?i/ file in the page named directory
    let pdi = page / "_index" & ext
    if fileExists(pdi):
      content &= readFile(pdi)
  if content == "":
    return content

  # Removed for security - could potentially open any file on file system
  #if fileExists(page):
  #  return readFile(page)
  
  return content

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
    var content = site.getContent(req.url.path)
    let (status,meta) = content.checkStatusCodes()
    content = content.addHeaderAndFooter(site)
    let furl = req.url.hostname / req.url.path
    case status:
      of 20:
        echo "Found : ", req.url.hostname / req.url.path
        await req.respond(Success, "text/gemini", content)
      of 30:
        echo "TempRedirect : ", furl , " to ", meta
        await req.respond(Redirect, meta)
      of 31:
        echo "TempRedirect : ", furl , " to ", meta
        await req.respond(Redirect, meta)
      of 51:
        echo "NotFound : ", furl
        await req.respond(NotFound, "Page Not Found.")
      else:
        echo "Server Unavailable : ", furl
        await req.respond(ServerUnavailable, "Unknown Error")
  except:
    echo "ERROR: " & getCurrentExceptionMsg()
    await req.respond(ERROR, "Server Error")


when isMainModule:
  if len(nemini.listeners) > 0:
    echo "Starting Nemini version : " & nemini.version
    for l in nemini.listeners:
      echo "Starting listener on port : ", l.port
      if l.hasCerts() and len(l.sites) > 0:
        try:
          var server = newAsyncGeminiServer(certFile = l.cert.fullchain, keyFile = l.cert.private_key)
          # TODO send the listener into the handle callback for less work finding the site later
          asyncCheck server.serve(Port(l.port), handle)
          echo "Started on port : ", l.port
        except:
          echo "Failed to open certificate - do you have permission?"
      else:
        echo "No Certificate found for Listener : ", l.port, ". Not Starting."
    runForever()
