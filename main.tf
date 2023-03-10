#####
# NS Hostname
#####
resource "citrixadc_nshostname" "base_hostname" {
   hostname = var.adc-base.hostname
}

#####
# Add IP addresses
#####
resource "citrixadc_nsip" "snip" {
  ipaddress = var.adc-base-snip.ip
  netmask   = var.adc-base-snip.netmask
  type      = var.adc-base-snip.type
  icmp      = var.adc-base-snip.icmp
}

#####
# Configure the ADC timezone
#####
resource "citrixadc_nsparam" "nsparam" {
  timezone = var.adc-base.timezone
}

#####
# Configure Modes
#####
resource "citrixadc_nsmode" "base_nsmode" {
  bridgebpdus = false
  cka = false
  dradv = false
  dradv6 = false
  edge = true
  fr = true
  iradv = false
  l2 = false
  l3 = false
  mbf = false
  mediaclassification = false
  pmtud = true
  sradv = false
  sradv6 = false
  tcpb = false
  ulfd = false
  usnip = true
  usip = false
}

#####
# Configure Features
#####
resource "citrixadc_nsfeature" "base_nsfeature" {
  aaa = true
  adaptivetcp = false
  apigateway = false
  appflow = false
  appfw = false
  appqoe = false
  bgp = false
  bot = false
  cf = false
  ch = false
  ci = false
  cloudbridge = false
  cmp = false
  contentaccelerator = false
  cqa = false
  cr = false
  cs = true
  feo = false
  forwardproxy = false
  gslb = false
  hdosp = false
  ic = false
  ipv6pt = false
  isis = false
  lb = true
  lsn = false
  ospf = false
  pq = false
  push = false
  rdpproxy = false
  rep = false
  responder = true
  rewrite = true
  rip = false
  rise = false
  sp = false
  ssl = true
  sslinterception = false
  sslvpn = true
  urlfiltering = false
  videooptimization = false
  wl = false
}

#####
# Add a http Profile
#####
resource "citrixadc_nshttpprofile" "base_http_prof_democloud" {
  name = "http_prof_democloud"
  dropinvalreqs = "ENABLED"
  markhttp09inval = "ENABLED"
  markconnreqinval = "ENABLED"
  weblog = "DISABLED"
}

#####
# Add a TCP Profile
#####
resource "citrixadc_nstcpprofile" "base_tcp_prof_democloud" {
  name = "tcp_prof_democloud"
  ws = "ENABLED"
  sack = "ENABLED"
  wsval = "8"
  mss = "1460"
  initialcwnd = "10"
  oooqsize = "300"
  buffersize = "131072"
  flavor = "BIC"
  sendbuffsize = "131072"
  rstmaxack = "ENABLED"
  spoofsyndrop = "DISABLED"
  frto = "ENABLED"
  fack = "ENABLED"
  nagle = "ENABLED"
  dynamicreceivebuffering = "ENABLED"
  drophalfclosedconnontimeout = "ENABLED"
  dropestconnontimeout = "ENABLED"
}

#####
# Save config
#####
resource "citrixadc_nsconfig_save" "base_save" {  
  all  = true
  timestamp  = timestamp()

  depends_on = [
    citrixadc_nsconfig_save.base_save,
    citrixadc_nsfeature.base_nsfeature,
    citrixadc_nshostname.base_hostname,
    citrixadc_nshttpprofile.base_http_prof_democloud,
    citrixadc_nsip.snip,
    citrixadc_nsmode.base_nsmode,
    citrixadc_nsparam.nsparam,
    citrixadc_nstcpprofile.base_tcp_prof_democloud
  ]
}

#####
# Wait a few seconds
#####
resource "time_sleep" "base_wait_a_few_seconds" {

  create_duration = "15s"

  depends_on = [
    citrixadc_nsconfig_save.base_save
  ]

}