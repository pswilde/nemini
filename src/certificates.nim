import os,sugar,osproc,sequtils
import config

proc createCerts*(l: Listener): bool =
  createDir("certs")
  let base_site = l.sites[0]
  echo "Creating certificates for ", base_site.name
  let cn = base_site.base_url
  var alt_names = collect:
    for an in base_site.aliases:
      an
  let alt_sites_cn = collect:
    for n in l.sites:
      n.base_url
  alt_names = alt_names.concat(alt_sites_cn)
  let alt_sites_alt_names = collect:
    for n in l.sites:
      for an in n.aliases:
        an
  alt_names = alt_names.concat(alt_sites_alt_names)
  echo alt_names
  var cmd = "openssl req -new -newkey rsa:4096 -days " & $l.cert.days & " "
  cmd    &= "-subj \"/C=" & l.cert.country & "/ST=" & l.cert.state & "/L=" & l.cert.locality & "/O=" & l.cert.organization & "/CN=" & cn & "\" "
  if len(alt_names) > 0:
    var san = "-addext \"subjectAltName="
    for n in alt_names:
      san  &= "DNS:" & n & ", "
    san = san[0 .. ^3]
    san &= "\" "
    cmd &= san
  cmd    &= "-nodes -x509 -keyout " & l.cert.private_key & " -out " & l.cert.fullchain
  let output = execCmd(cmd)
  return output == 0

proc hasCerts*(l: Listener): bool =
  if fileExists(l.cert.fullchain) and fileExists(l.cert.private_key):
    echo "Listener has cert : ", l.port
    return true
  else:
    return createCerts(l)
  return false
