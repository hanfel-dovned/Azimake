/-  azimake
/+  dbug, default-agent, server, schooner
/*  ui  %html  /app/azimake/html
::
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-0  [%0 =apps:azimake blocked=(set ship)]
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
    (handle-create-action !<(create-action:azimake +.cage))
  ==
::
++  handle-app-action
  |=  [=id:azimake act=app-action:azimake]
  ^+  that
  ?<  (gth src.bowl 0xffff.ffff)
  =/  app  
    ^-  app:azimake  
    (~(got by apps) id)
  =-  that(apps (~(put by apps) id [ui.app - published.app]))  
  ?-    -.act
      %put-in-map
    %+  ~(put by county.app) 
      src.bowl
    =/  user-map  (~(get by county.app) src.bowl)
    ?~  user-map
      (malt (limo [key.act value.act]~))
    (~(put by u.user-map) key.act value.act)
  ==
::
++  handle-create-action
  |=  act=create-action:azimake
  ^+  that
  ?>  =(src.bowl our.bowl)
  ?-    -.act
      %save
    =;  new
      that(apps (~(put by apps) id.act new))
    =/  old  `(unit app:azimake)`(~(get by apps) id.act)
    :-  ui.act
    ?~  old
      [~ %.n]
    [county.u.old published.u.old]
  ::
      %publish
    =/  old  `app:azimake`(~(got by apps) id.act)
    =/  new  [ui.old county.old %.y]
    that(apps (~(put by apps) id.act new))
  ::
      %unpublish
    =/  old  `app:azimake`(~(got by apps) id.act)
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
    =/  old  `app:azimake`(~(got by apps) id.act)
    :+  ui.old 
      (~(del by county.old) ship.act) 
    published.old
  ==
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
      ?<  (gth src.bowl 0xffff.ffff) ::must be a planet to POST
      =/  json  (de:json:html q.u.body.request.inbound-request)
      =/  act  (dejs-app-action +.json)
      =/  id  +14:site
      =/  app  `app:azimake`(~(got by apps) id)
      ?>  ?|  =(%.y published.app)
              =(src.bowl our.bowl)
          ==
      =.  that  (handle-app-action [id act])
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
      =/  app
        ^-  app:azimake
        (~(got by apps) id)
      ?>  ?|  =(%.y published.app)
              =(src.bowl our.bowl)
          ==
      =/  fe  ui.app
      [200 ~ [%html fe]]
    ::
        [%apps %azimake @ %state ~]
      =/  id  +14:site
      =/  app
        ^-  app:azimake
        (~(got by apps) id)
      ?>  ?|  =(%.y published.app)
              =(src.bowl our.bowl)
          ==
      =/  ct  county.app
      [200 ~ [%json (enjs-county ct)]]
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
  |=  =county:azimake
  ^-  json
  %-  pairs
  :~
      [%host [%s (scot %p our.bowl)]]
      [%user [%s (scot %p src.bowl)]]
      ::
      :-  %data
      %-  pairs
      %+  turn
        ~(tap by county)
      |=  [user=@p m=(map =key:azimake =value:azimake)]
      :-  (scot %p user)
      %-  pairs
      %+  turn
        ~(tap by m)
      |=  [=key:azimake =value:azimake]
      :-  key
      [%s value]
  ==
::
++  enjs-apps
  =,  enjs:format
  |=  =apps:azimake
  ^-  json
  %-  pairs
  %+  turn
    ~(tap by apps)
  |=  [=id:azimake =app:azimake]
  :-  id
  %-  pairs
  :~  [%ui [%s ui:app]]
      [%published [%b published:app]]
  ==
::
++  dejs-app-action
  =,  dejs:format
  |=  jon=json
  ^-  app-action:azimake
  %.  jon
  %-  of
  :~  [%put-in-map (ot ~[key+so value+so])]  
  ==
::
++  dejs-create-action
  =,  dejs:format
  |=  jon=json
  ^-  create-action:azimake
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
--