import os,strutils,tables
import parsetoml

type
  Nemini* = object
    listeners*: seq[Listener]
  Listener* = object
    port*: int
    sites*: seq[Site]
    fullchain*: string
    private_key*: string
  Site* = object
    name*: string
    base_url*: string
    aliases*: seq[string]
    root_dir*: string
    index*: string

proc newSite(): Site =
  return Site(index: "index.gemini")

proc newListener(): Listener =
  return Listener(port: 1965)

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
  var nemini = Nemini()
  var cfg = "./config/nemini.sample.toml"
  if file != "":
    cfg = file
    echo cfg, "1"
  else:
    if fileExists("/etc/nemini/nemini.toml"):
      cfg = "/etc/nemini/nemini.toml"
      echo cfg, "2"
    elif fileExists("./config/nemini.toml"):
      cfg = "./config/nemini.toml"
      echo cfg, "3"
  echo "Using config from : ", cfg
  if not fileExists(cfg):
    echo "Config file does not exist"
    return 
  let toml = parsetoml.parseFile(cfg)
  for l in toml["listeners"].getElems:
    var listener = newListener()
    listener.fullchain = l.getOrDefault("fullchain").getStr
    listener.private_key = l.getOrDefault("private_key").getStr
    if l.hasKey("port"):
      listener.port = l.getOrDefault("port").getInt
    for s in l["sites"].getElems:
      listener.sites.add(getSiteConfig(s))
    if listener.fullchain == "":
      listener.fullchain = "certs/" & listener.sites[0].base_url & ".cert"
    if listener.private_key == "":
      listener.private_key = "certs/" & listener.sites[0].base_url & ".key"
    nemini.listeners.add(listener)
  return nemini

