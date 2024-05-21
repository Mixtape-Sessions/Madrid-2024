#set page(
  paper: "us-letter",
  margin: 36pt
)
#set text(font: "Poppins", size: 11pt)
#set par(leading: 0.75em)
#show par: set block(spacing: 1.2em)
#show heading: set block(above: 32pt, below: 16pt)
#show link: it => underline(stroke: 1.5pt + rgb("#e63274"), it)


#figure(image(width: 65%, "banner.png"))

= Greetings!

Welcome to CodeChella Madrid. This is the first time Mixtape Sessions has done an in-person event, so we are nervous but very excited to try it! This document contains the essential information you'll need for this workshop. 

If you still have questions after looking through this document, then please do not hestiate to email any questions. There are three people you can contact, but typically you should email Scott and Kyle. Additionally, our local host is Agustín an associate professor at CUNEF Universidad. There may be some questions better asked to him, but we can cc him if needed. Our emails are as follows:

#grid(
  columns: (1fr, 2fr),

  inset: (x: 0pt, y: 8pt),
  [Kyle Butts], [#link("mailto:buttskyle96@gmail.com")],
  [Scott Cunningham], [#link("causalinf@mixtape.consulting")],
  [Agustín Casas Lupiáñez], [#link("acasas@cunef.edu")],
)


= Course Material

The entire course material will be hosted on a github repository https://github.com/Mixtape-Sessions/Madrid-2024. It is currently a work-in-progress, but all the material will be uploaded by the end of the workshop.

During the workshop, we will have live coding portions where we will ask attendees to try coding up these estimators themselves and try out interactive apps. For this reason, we recommend everyone bring their laptops to the workshops. 

= Discord

We will be using discord during this workshop. We will monitor the discord during the workshop for any questions that may be off-topic but you want to ask about. But more importantly, we want people to be able to meet one another and make plans for dinner and things like that. So, I recommend joining early and saying hi in the `#meeting-eachother` channel! To join, use this link: https://discord.gg/uTkJykKwNf.


= Coffee and Food 

Each morning of the workshop at 10:30am, fresh coffee and pastries will be provided outside the auditorium. Lunch will take place from 1 — 2:30pm each day. You grab a bite either at the campus cafeteria or head to the surrounding area. On Wednesday, food is generously being provided by CUNEF Universidad for us. A lot of restaurants are to the south on Av. de la Reina Victoria and to the East. 



// #pagebreak()
= Schedule

This is our tentative schedule. Note that on Wednesday, May 29th, we will be going to a different lecture hall. The reason is that on this day, lunch will be provided for attendees by CUNEF Universidad.

#[
  #set text(size: 9pt)
  #table(
    columns: (1.4fr, 2fr, 2fr, 2fr, 2fr),
    rows: (auto, auto, 40pt, auto, auto),
    inset: (x: 8pt, y: 10pt),
    align: (x, y) => if y == 0 { 
      center 
    } else if x == 0 or y == 2 {
      horizon + center
    } else  { 
      left
    },
    fill: (x, y) => if y == 0 or x == 0 {
      gray.lighten(60%)
    } else if y == 2 { 
      gray.lighten(80%)
    },
    table.header(
      [], 
      [*Day 1* \ Monday, May 27    \ #v(5pt) CUNEF Auditorium],	
      [*Day 2* \ Tuesday, May 28   \ #v(5pt) CUNEF Auditorium], 
      [*Day 3* \ Wednesday, May 29 \ #v(5pt) *Aula Magna*], 
      [*Day 4* \ Thursday, May 30  \ #v(5pt) CUNEF Auditorium]
    ),
    [9 — 1pm], 
      [ _Scott Cunningham_ \ #v(5pt) Core DID],
      [ _Scott Cunningham_ \ #v(5pt) Covariates],
      [ _Scott Cunningham_ \ #v(5pt) Callaway and Sant'anna \ & Sun and Abraham],
      [ _Kyle Butts_ \ #v(5pt) Imputation DID & Synth],
    [1 — 2:30pm], [Lunch], [Lunch], [_CUNEF_ \ Provides Lunch], [Lunch],
    [2:30 — 3:30pm], 
      [_Scott Cunningham_ \ #v(5pt) Core DID ],
      [_Scott Cunningham_ \ #v(5pt) Bacon Decomposition \ & Callaway and Sant'anna ],
      [_Scott Cunningham_ \ #v(5pt) Callaway and Sant'anna & Sun and Abraham ],
      [_Kyle Butts_ \ #v(5pt) Imputation DID & Synth ],
    [3:30 — 5pm], 
      table.cell(fill: maroon.lighten(80%), [Coding Lab]),
      table.cell(fill: maroon.lighten(80%), [Coding Lab]),
      table.cell(fill: orange.lighten(80%), [_Dan Rees &\ Mark Anderson_ \ #v(5pt) Doing Applied Research Workshop]),
      table.cell(fill: orange.lighten(80%), [_Dan Rees &\ Mark Anderson_ \ #v(5pt) Doing Applied Research Workshop])
  )
]

// #pagebreak()
= Location

#grid(
  columns: (1fr, 1fr), 
  inset: 10pt,
  figure(image(width: 100%, "cunef_building.png")),
  figure(image(width: 100%, "wednesday.png"))
)

On Monday, Tuesday, and Thursday, the event will be at CUNEF Universidad
at #link("https://maps.app.goo.gl/FPw2nM2cxf6s4Kmw9", [C. de Almansa, 101]). The left image shows the specific building and the entrance is marked on the map by the x. 

On Wednesday, we will be going to a different building (because of the provided lunch). It is #link("https://maps.app.goo.gl/CUnGBJz8xWyLMS6f6", [C. de Leonardo Prieto Castro, 2]). See the map on the right.

