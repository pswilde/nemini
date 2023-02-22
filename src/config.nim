import os,strutils
import parsetoml

type
  Nemini* = object
    version*: string
    listeners*: seq[Listener]
  Listener* = object
    port*: int
    sites*: seq[Site]
    cert*: Cert
  Cert* = object
    fullchain*: string
    private_key*: string
    days*: int
    country*: string
    state*: string
    locality*: string
    organization*: string
  Site* = object
    name*: string
    base_url*: string
    aliases*: seq[string]
    root_dir*: string
    index*: string

proc getVersion(): string =
  # Get the version number from nimble file
  # TODO probably a better way to do this but it works
  let c = staticRead("../nemini.nimble")
  let l = c.find("version")
  let e = c.find("=",l)
  let cr = c.find("\n",e)
  let v = c[e+1..cr-1]
  let version = v.strip(chars = {' ','"'})
  return version

const VERSION = getVersion()

proc newNemini*(): Nemini =
  return Nemini(version: VERSION)

proc newSite(): Site =
  return Site(index: "index.gemini")

proc newCert(): Cert =
  var c = Cert()
  c.days = 365
  c.country = "GB"
  c.state = "myState"
  c.locality = "myCity"
  c.organization = "myOrganizationName"
  return c

proc newListener(): Listener =
  return Listener(port: 1965, cert: newCert())

proc getSiteConfig(toml: TomlValueRef): Site =
  var site = newSite()
  site.name = toml.getOrDefault("name").getStr
  site.base_url = toml.getOrDefault("base_url").getStr
  if toml.hasKey("aliases"):
    for x in toml["aliases"].getElems:
      site.aliases.add(x.getStr)
  site.root_dir = toml.getOrDefault("root_dir").getStr
  if site.root_dir.contains("{pwd}"):
    site.root_dir = site.root_dir.replace("{pwd}",getCurrentDir())
  return site

proc getNeminiConfig*(file: string): Nemini =
  var nemini = newNemini()
  var cfg = "./config/nemini.sample.toml"
  if file != "":
    cfg = file
  else:
    if fileExists("/etc/nemini/nemini.toml"):
      cfg = "/etc/nemini/nemini.toml"
    elif fileExists("./config/nemini.toml"):
      cfg = "./config/nemini.toml"
  echo "Using config from : ", cfg
  if not fileExists(cfg):
    echo "Config file does not exist"
    quit(1)
  let toml = parsetoml.parseFile(cfg)
  for l in toml["listeners"].getElems:
    var listener = newListener()
    if l.hasKey("cert"):
      let cert = l["cert"].getTable
      listener.cert.fullchain = cert.getOrDefault("fullchain").getStr
      listener.cert.private_key = cert.getOrDefault("private_key").getStr
      if cert.hasKey("days"):
        listener.cert.days = cert["days"].getInt
      if cert.hasKey("country"):
        listener.cert.country = cert["country"].getStr
      if cert.hasKey("state"):
        listener.cert.state = cert["state"].getStr
      if cert.hasKey("locality"):
        listener.cert.locality = cert["locality"].getStr
      if cert.hasKey("organization"):
        listener.cert.organization = cert["organization"].getStr
    if l.hasKey("port"):
      listener.port = l.getOrDefault("port").getInt
    for s in l["sites"].getElems:
      listener.sites.add(getSiteConfig(s))
    if listener.cert.fullchain == "":
      listener.cert.fullchain = "certs/" & listener.sites[0].base_url & ".cert"
    if listener.cert.private_key == "":
      listener.cert.private_key = "certs/" & listener.sites[0].base_url & ".key"
    nemini.listeners.add(listener)
  return nemini

