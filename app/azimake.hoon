/-  az=azimake
/+  dbug, default-agent, server, schooner, naive, ethereum
/*  ui  %html  /app/azimake/html
::
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-0
  $:  %0 
      =apps:az 
      =challenges:az
      =sessions:az
      blocked=(set ship)
  ==
::
+$  card  card:agent:gall
--
::
%-  agent:dbug
=|  state-0
=*  state  -
::
^-  agent:gall
::
=<
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
    hc   ~(. +> [bowl ~])
::
++  on-init
  ^-  (quip card _this)
  =^  cards  state  abet:init:hc
  [cards this]
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =^  cards  state  abet:(load:hc vase)
  [cards this]
::
++  on-poke
  |=  =cage
  ^-  (quip card _this)
  =^  cards  state  abet:(poke:hc cage)
  [cards this]
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  [~ ~]
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  `this
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  `this
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  `this
::
++  on-fail   on-fail:def
++  on-leave  on-leave:def
--
::
|_  [=bowl:gall deck=(list card)]
+*  that  .
::
++  emit  |=(=card that(deck [card deck]))
++  emil  |=(lac=(list card) that(deck (welp lac deck)))
++  abet  ^-((quip card _state) [(flop deck) state])
::
++  init
  ^+  that
  %-  emit
  :*  %pass   /eyre/connect   
      %arvo  %e  %connect
      `/apps/azimake  %azimake
  ==
::
++  load
  |=  =vase
  ^+  that
  ?>  ?=([%0 *] q.vase)
  that(state !<(state-0 vase))
::
++  poke
  |=  =cage
  ^+  that
  ?+    -.cage  !!
      %handle-http-request
    (handle-http !<([@ta =inbound-request:eyre] +.cage))
      %azimake-create-action
    (handle-create-action !<(create-action:az +.cage))
  ==
::
++  handle-app-action
  |=  [=id:az act=app-action:az]
  ^+  that
  =/  user  get-user
  ?<  (gth user 0xffff.ffff)
  =/  app  `app:az`(~(got by apps) id) 
  ?-    -.act
      %put-in-map
    =-  that(apps (~(put by apps) id [ui.app - published.app])) 
    %+  ~(put by county.app) 
      user
    =/  user-map  (~(get by county.app) user)
    ?~  user-map
      (malt (limo [key.act value.act]~))
    (~(put by u.user-map) key.act value.act)
  ::
      %auth
    ?.  (validate +.act)
      !!
    %=  that
      sessions  (~(put by sessions) [src.bowl who.act])
    ==
  ==
::
++  handle-create-action
  |=  act=create-action:az
  ^+  that
  ?>  =(src.bowl our.bowl)
  ?-    -.act
      %save
    =;  new
      %=  that
        apps  (~(put by apps) id.act new)
        challenges  ~  :: XX lazy bad way of clearing challenges semi-regularly
      ==
    =/  old  `(unit app:az)`(~(get by apps) id.act)
    :-  ui.act
    ?~  old
      [~ %.n]
    [county.u.old published.u.old]
  ::
      %publish
    =/  old  `app:az`(~(got by apps) id.act)
    =/  new  [ui.old county.old %.y]
    that(apps (~(put by apps) id.act new))
  ::
      %unpublish
    =/  old  `app:az`(~(got by apps) id.act)
    =/  new  [ui.old county.old %.n]
    that(apps (~(put by apps) id.act new))
  ::
      %block-user
    that(blocked (~(put in blocked) ship.act))
  ::
      %unblock-user
    that(blocked (~(del in blocked) ship.act))
  ::
      %destroy-app
    that(apps (~(del by apps) id.act))
  ::
      %delete-user-data
    =;  new
      that(apps (~(put by apps) id.act new))
    =/  old  `app:az`(~(got by apps) id.act)
    :+  ui.old 
      (~(del by county.old) ship.act) 
    published.old
  ==
::
++  get-user
  ^-  @p
  ?.  (gth src.bowl 0xffff.ffff)
    src.bowl
  (~(got by sessions) src.bowl)
::
++  handle-http
  |=  [eyre-id=@ta =inbound-request:eyre]
  ^+  that
  =/  ,request-line:server
    (parse-request-line:server url.request.inbound-request)
  =+  send=(cury response:schooner eyre-id)
  ::
  ?+    method.request.inbound-request
    (emil (flop (send [405 ~ [%stock ~]])))
    ::
      %'POST'
    ?~  body.request.inbound-request  !!
    ?+    site  (emil (flop (send [404 ~ [%plain "404 - Not Found"]])))
    ::
        [%apps %azimake ~]
      ?>  =(our.bowl src.bowl)
      =/  json  (de:json:html q.u.body.request.inbound-request)
      =/  act  (dejs-create-action +.json)
      =.  that  (handle-create-action act)
      (emil (flop (send [200 ~ [%none ~]])))
    ::
        [%apps %azimake @ ~]
      ?<  (gth get-user 0xffff.ffff)
      =/  json  (de:json:html q.u.body.request.inbound-request)
      =/  act  (dejs-app-action +.json)
      =/  id  +14:site
      =/  app  `app:az`(~(got by apps) id)
      ?>  ?|  =(%.y published.app)
              =(src.bowl our.bowl)
          ==
      =.  that  
        (handle-app-action [id act])
      (emil (flop (send [200 ~ [%none ~]])))
    ==
    ::
      %'GET'
    %-  emil
    %-  flop
    %-  send
    ?+    site  [404 ~ [%plain "404 - Not Found"]]
    ::
        [%apps %azimake ~]
      ?>  =(our.bowl src.bowl)
      [200 ~ [%html ui]]
    ::
        [%apps %azimake %list-of-apps-as-json ~]
      ?>  =(our.bowl src.bowl)
      [200 ~ [%json (enjs-apps apps)]]
    ::
        [%apps %azimake @ ~]
      =/  id  +14:site
      =/  app  `app:az`(~(got by apps) id)
      ?>  ?|  =(%.y published.app)
              =(src.bowl our.bowl)
          ==
      =/  fe  ui.app
      [200 ~ [%html fe]]
    ::
        [%apps %azimake @ %state ~]
      =/  id  +14:site
      =/  app  `app:az`(~(got by apps) id)
      ?>  ?|  =(%.y published.app)
              =(src.bowl our.bowl)
          ==
      ::  If this is a new comet, record them.
      =?    sessions
          !(~(has by sessions) src.bowl)
        (~(put by sessions) [src.bowl src.bowl])
      ::  If they haven't mask-authed, create a new challenge.
      =/  new-challenge  (sham [now eny]:bowl)
      =?    challenges
          =(src.bowl (~(got by sessions) src.bowl))
        (~(put in challenges) new-challenge)
      =/  ct  county.app
      [200 ~ [%json (enjs-county [ct new-challenge])]]
    ::
        [%apps %azimake @ %eauth ~]
      =/  redirect
        %-  crip 
        ['/' 'apps' '/' 'azimake' '/' +14:site '&eauth' ~]
      [302 ~ [%login-redirect redirect]] 
    ==  
  ==
::
++  enjs-county
  =,  enjs:format
  |=  [=county:az challenge=secret:az]
  ^-  json
  %-  pairs
  :~  [%challenge [%s (scot %uv challenge)]]
      [%host [%s (scot %p our.bowl)]]
      [%user [%s (scot %p get-user)]]
      ::
      :-  %data
      %-  pairs
      %+  turn
        ~(tap by county)
      |=  [user=@p m=(map =key:az =value:az)]
      :-  (scot %p user)
      %-  pairs
      %+  turn
        ~(tap by m)
      |=  [=key:az =value:az]
      :-  key
      [%s value]
  ==
::
++  enjs-apps
  =,  enjs:format
  |=  =apps:az
  ^-  json
  %-  pairs
  %+  turn
    ~(tap by apps)
  |=  [=id:az =app:az]
  :-  id
  %-  pairs
  :~  [%ui [%s ui:app]]
      [%published [%b published:app]]
  ==
::
++  dejs-app-action
  =,  dejs:format
  |=  jon=json
  ^-  app-action:az
  %.  jon
  %-  of
  :~  [%put-in-map (ot ~[key+so value+so])]  
      [%auth (ot ~[who+(se %p) secret+(se %uv) address+sa signature+sa])]
  ==
::
++  dejs-create-action
  =,  dejs:format
  |=  jon=json
  ^-  create-action:az
  %.  jon
  %-  of
  :~  [%save (ot ~[id+so ui+so])]  
      [%publish (ot ~[id+so url+so])]
      [%unpublish (ot ~[id+so url+so])]
      [%block-user (ot ~[user+(se %p)])]
      [%unblock-user (ot ~[user+(se %p)])]
      [%destroy-app (ot ~[id+so])]
      [%delete-user-data (ot ~[id+so user+(se %p)])]  
  ==
::
::  Modified from ~rabsef-bicrym's %mask
++  validate
  |=  [who=@p challenge=secret:az address=tape hancock=tape]
  ^-  ?
  =/  addy  (from-tape address)
  =/  cock  (from-tape hancock)
  =/  owner  (get-owner who)
  ?~  owner  %.n
  ?.  =(addy u.owner)  %.n
  ?.  (~(has in challenges) challenge)  %.n
  =/  note=@uvI
    =+  octs=(as-octs:mimes:html (scot %uv challenge))
    %-  keccak-256:keccak:crypto
    %-  as-octs:mimes:html
    ;:  (cury cat 3)
      '\19Ethereum Signed Message:\0a'
      (crip (a-co:co p.octs))
      q.octs
    ==
  ?.  &(=(20 (met 3 addy)) =(65 (met 3 cock)))  %.n
  =/  r  (cut 3 [33 32] cock)
  =/  s  (cut 3 [1 32] cock)
  =/  v=@
    =+  v=(cut 3 [0 1] cock)
    ?+  v  !!
      %0   0
      %1   1
      %27  0
      %28  1
    ==
  ?.  |(=(0 v) =(1 v))  %.n
  =/  xy
    (ecdsa-raw-recover:secp256k1:secp:crypto note v r s)
  =/  pub  :((cury cat 3) y.xy x.xy 0x4)
  =/  add  (address-from-pub:key:ethereum pub)
  =(addy add)
::
++  from-tape
  |=(h=tape ^-(@ux (scan h ;~(pfix (jest '0x') hex))))
::
++  get-owner
  |=  who=@p
  ^-  (unit @ux)
  =-  ?~  pin=`(unit point:naive)`-
        ~
      ?.  |(?=(%l1 dominion.u.pin) ?=(%l2 dominion.u.pin))
        ~
      `address.owner.own.u.pin
  .^  (unit point:naive)
    %gx
    /(scot %p our.bowl)/azimuth/(scot %da now.bowl)/point/(scot %p who)/noun
  ==
--