# FRI - Diplomsko Delo

## Pediatko - Mobilni predvajalnik za ranljive skupine v bolnišnicah


Zaradi potrebe po izboljšanju počutja otrok v bolnišnicah je bila izražena želja po razvoju aplikacije, ki bi pomagala pri sprostitvi otrok s pravljicami in glasbeno terapijo.
Cilj diplomske naloge je bil razviti mobilno aplikacijo, dostopno čim večim napravam, ki otrokom pomaga pri boljšem počutju z implementacijo predvajalnika, ki pridobi določene zgodbe iz RTV-ja.


Zgodbice so razdeljene na več tematik. Nekatere namenjene uspavanju, druge za pomoč pri stiski otrok zaradi operacije ali pregleda, opogumljanju otrok pri kreativnosti in ustvarjanju itd..


Tematike se lahko med sabo poljubno tudi zamenjavajo po želji RTV-ja.


V okviru diplomske naloge je bila razvita aplikacija, ki vsebuje vpis v aplikacijo ter tri glavna okna.
1. šest različnih tematik seznamov predvajanja, kjer vsaka vsebuje nabor vseh posnetkov tematike
2. v živo predvajujoči se Radio Z (Radio Pediatko)
3. Anketa, ki jo lahko uporabniki prostovoljno izpolnejo


Mobilna aplikacija je napisana v jeziku Dart s pomočjo ogrodja Flutter.


### Odvisnost od paketov:
* just_audio & just_audio_background &emsp;&emsp; ***(predvajanje vsebine z možnostjo predvajanja v ozadju)***
* webview_flutter &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; ***(webview za spletno anketo)***
* google_fonts &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; ***(nabor različnih pisav)***
* flutter_secure_storage &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; ***(shranjevanje informacije kot je geslo za vpis)***
* intl &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; &emsp; ***(formatiranje datuma)***
* flutter_native_splash &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;***(pozdravni zaslon)***


## Slike
Vpisni zaslon z animiranim indikatorjem, ki opozori uporabnika o vpisu napačnega / pravilnega gesla pred odprtjem nove strani
<p align="center">
<img src="https://user-images.githubusercontent.com/65168787/185938585-d8d38c98-f692-4e40-865d-92bbff734c23.jpg" width="300">
</p>

<br>

Glavna, prva stran, na kateri se nahaja 6 tem s predvajalnimi vsebinami


<p align="center">
<img src="https://user-images.githubusercontent.com/65168787/185938660-79947f92-2fc6-4263-bb45-642a22454499.jpg" width="300">
</p>

<br>

Seznam predvajalnika ter predvajalnik za posamezne vsebina


<p align="center">
|<img src="https://user-images.githubusercontent.com/65168787/185938694-56fcbac0-c127-4b1d-b6c3-1b4cf6ae38fa.jpg" width="300">
<img src="https://user-images.githubusercontent.com/65168787/185938783-af822dd8-379b-48e6-8345-1128f4490ee5.jpg" width="300">|
</p>

<br>

Predvajalnik za Radio Z (Radio Pediatko)

<p align="center">
<img src="https://user-images.githubusercontent.com/65168787/185938798-61636f64-3d65-48d4-9e28-011818524344.jpg" width="300">
</p>

<br>

Webview za bodočo anketo

<p align="center">
<img src="https://user-images.githubusercontent.com/65168787/185938804-c3bc3bbd-3168-400a-bbaf-7fbde57c58d4.jpg" width="300">
</p>


