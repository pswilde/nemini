import asyncdispatch,os,sugar
import gemini
import parsetoml

type
  Nemini = object
    sites: seq[Site]
  Site = object
    name: string
    base_url: string
    aliases: seq[string]
    root_dir: string
    index: string
    fullchain: string
    private_key: string
    port: int

proc newSite(): Site =
  return Site(index: "index.gemini", port: 1965)

proc getPage(s: Site, path: string): string =
  var p = path
  if path == "" or path == "/":
    p = s.index
  let page = s.root_dir / p
  let 
    page_gemini = page & ".gemini"
    page_gmi = page & ".gmi"
    page_gmni = page & ".gmni"
  if fileExists(page):
    return readFile(page)
  elif fileExists(page_gemini):
    return readFile(page_gemini)
  elif fileExists(page_gmi):
    return readFile(page_gmi)
  elif fileExists(page_gmni):
    return readFile(page_gmni)
  else:
    return ""

proc getConfig(): Nemini =
  var nemini = Nemini()
  for f in walkDir("config"):
    var site = newSite()
    let toml = parsetoml.parseFile(f.path)
    site.name = toml.getOrDefault("name").getStr
    site.base_url = toml.getOrDefault("base_url").getStr
    if toml.hasKey("aliases"):
      for x in toml["aliases"].getElems:
        site.aliases.add(x.getStr)
    site.root_dir = toml.getOrDefault("root_dir").getStr
    site.fullchain = toml.getOrDefault("fullchain").getStr
    site.private_key = toml.getOrDefault("private_key").getStr
    if toml.hasKey("port"):
      site.port = toml.getOrDefault("port").getInt
    nemini.sites.add(site)
  return nemini

let config = getConfig()

proc findSite(url: string): Site =
  # TODO we might want to use multiple urls so maybe save some alias in a sequence and check those too?
  let site = collect:
    for s in config.sites:
      if s.base_url == url or s.aliases.contains(url):
        s
  return site[0]

proc handle(req: AsyncRequest) {.async.} =
  # TODO go and find the site - not ideal, need to work out how to send the site the callback
  let site = findSite(req.url.hostname)
  # TODO if a file exists in the root directory use it, if not show an error
  let page = site.getPage(req.url.path)
  if page != "":
    echo "OK : ", req.url.path
    await req.respond(Success, "text/gemini", page)
  else:
    echo "NotFound : ", req.url.path
    await req.respond(NotFound, "text/gemini", "# Page Not Found!")

when isMainModule:
  echo "Starting Nemini..."
  for site in config.sites:
    echo "Starting site ", site.name
    var server = newAsyncGeminiServer(certFile = site.fullchain, keyFile = site.private_key)
    # TODO send the site into the handle callback for less work finding the site later
    asyncCheck server.serve(Port(site.port), handle)
  runForever()
