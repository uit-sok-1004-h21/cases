For å illustrere vekst vil vi benytte bruttonasjonalprodukt (BNP) fra
Statistisk Sentralbyrå (SSB). Data finnes i tabell “09842: BNP og andre
hovedstørrelser (kr per innbygger), etter statistikkvariabel og år”.
Tabellen inneholder årlige data fra 1970 over utviklingen i BNP, målt i
kroner per innbygger.

## SSB - åpne data

SSB gir oss tilgang til sine data via en
<a href="https://www.ssb.no/omssb/tjenester-og-verktoy/api" target="blank">API</a>.
API står for “Application Programming Interface” og er en forkortelse
for software som gjør at to applikasjoner kan kommunisere med hverandre.
Hver gang du bruker en app som Facebook, sender en bilde i Snapchat
eller sjekker været på telefonen din, så bruker du en API.

SSB tilbyr en API med
<a href="https://data.ssb.no/api/v0/dataset/" target="blank">ferdige datasett</a>.
Her er det omtrent 250 oppdaterte datasett med en fast URL over de mest
brukte tabellene i Statistikkbanken. Disse er dermed enkelt
tilgjengelig, og vi skal se nærmere på noen av dem senere.

For å få tilgang til tabellen med bruttonasjonalprodukt må vi benytte
<a href="https://www.ssb.no/omssb/tjenester-og-verktoy/api/px-api" target="blank">API:Lag egne datasett</a>.
Her finner du en
<a href="https://data.ssb.no/api/v0/no/console/" target="blank">API konsoll</a>
med en søkefunksjon. Vi søker på “bnp” og får opp følgende resultat i
API konsollet:

![**API konsoll**](images/api_konsoll.png)

Her ser vi hvilken *url* tabellen for bruttonasjonalprodukt har:
“`https://data.ssb.no/api/v0/no/table/09842`”, dersom du går til
<a href="https://data.ssb.no/api/v0/no/table/09842" target="blank">denne nettsiden</a>
vil du se tabellen i
<a href="https://json-stat.org/" target="blank">JSON-stat</a> format. Vi
ser også hvilke variabler tabellen inneholder.

### Data via kode

Vi skal nå benytte `R`
<a href="https://www.ssb.no/omssb/tjenester-og-verktoy/api/px-api/eksempler-pa-kode" target="blank">kode for å trekke ut data</a>.
SSB har laget en `R` pakke
<a href="https://cran.r-project.org/web/packages/PxWebApiData/index.html" target="blank">PxWebApiData</a>
som vi skal ta i bruk. Du finner
<a href="https://cran.r-project.org/web/packages/PxWebApiData/vignettes/Introduction.html" target="blank">eksempel på bruk i denne lenken</a>.

### BNP tabell

Vi starter med å laste nødvendige `R` pakker.

``` r
library(PxWebApiData)
library(tidyverse)
```

    -- Attaching packages --------------------------------------- tidyverse 1.3.1 --

    v ggplot2 3.3.3     v purrr   0.3.4
    v tibble  3.1.2     v dplyr   1.0.6
    v tidyr   1.1.3     v stringr 1.4.0
    v readr   1.4.0     v forcats 0.5.1

    -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    x dplyr::filter() masks stats::filter()
    x dplyr::lag()    masks stats::lag()

Ta også en titt på
<a href="https://www.ssb.no/omssb/tjenester-og-verktoy/api/px-api/_attachment/248256?_ts=1746cce27a0" target="blank">brukerveiledningen</a>
til `PxWebApiData` pakken.

Meta informasjon om tabellen kan finnes med å benytte opsjonen
`returnMetaFrames = TRUE` i spørringen.

``` r
variabler <- ApiData("http://data.ssb.no/api/v0/no/table/09842", returnMetaFrames = TRUE)
names(variabler)
```

    [1] "ContentsCode" "Tid"         

Vi har metavariablene `ContentsCode` og `Tid`. Vi kan nå se på hvilke
verdier disse to variablene tar med spørringen:

``` r
verdier <- ApiData("https://data.ssb.no/api/v0/no/table/09842/", returnMetaData = TRUE)
verdier
```

    [[1]]
    [[1]]$code
    [1] "ContentsCode"

    [[1]]$text
    [1] "statistikkvariabel"

    [[1]]$values
    [1] "BNP"        "BNI"        "NI"         "DispINorge" "KonsumHIO" 
    [6] "MEMOBNP"   

    [[1]]$valueTexts
    [1] "Bruttonasjonalprodukt"                           
    [2] "Bruttonasjonalinntekt"                           
    [3] "Nasjonalinntekt"                                 
    [4] "Disponibel inntekt for Norge"                    
    [5] "Konsum i husholdninger og ideelle organisasjoner"
    [6] "MEMO: Bruttonasjonalprodukt. Faste 2015-priser"  


    [[2]]
    [[2]]$code
    [1] "Tid"

    [[2]]$text
    [1] "år"

    [[2]]$values
     [1] "1970" "1971" "1972" "1973" "1974" "1975" "1976" "1977" "1978" "1979"
    [11] "1980" "1981" "1982" "1983" "1984" "1985" "1986" "1987" "1988" "1989"
    [21] "1990" "1991" "1992" "1993" "1994" "1995" "1996" "1997" "1998" "1999"
    [31] "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009"
    [41] "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
    [51] "2020"

    [[2]]$valueTexts
     [1] "1970" "1971" "1972" "1973" "1974" "1975" "1976" "1977" "1978" "1979"
    [11] "1980" "1981" "1982" "1983" "1984" "1985" "1986" "1987" "1988" "1989"
    [21] "1990" "1991" "1992" "1993" "1994" "1995" "1996" "1997" "1998" "1999"
    [31] "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009"
    [41] "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
    [51] "2020"

    [[2]]$time
    [1] TRUE

Vi har nå nok informasjon om strukturen av denne tabellen til at vi kan
kjøre en spørring på `ContentsCode = BNP` og `Tid = 1970-2019`.

``` r
tabell <- ApiData("https://data.ssb.no/api/v0/no/table/09842/",
                Tid = paste(1970:2019),
                ContentsCode = "BNP")
```

Resultatet er en liste som vi kaller `tabell`.

![**Listen “tabell” i konsoll i RStudio**](images/tabell_liste.png)

Vi ser at begge listene inneholder en `data.frame` men med litt ulike
“labels”. Vi kan se på den første listen:

``` r
head(tabell[[1]])
```

         statistikkvariabel   år value
    1 Bruttonasjonalprodukt 1970 23616
    2 Bruttonasjonalprodukt 1971 26363
    3 Bruttonasjonalprodukt 1972 29078
    4 Bruttonasjonalprodukt 1973 32805
    5 Bruttonasjonalprodukt 1974 37734
    6 Bruttonasjonalprodukt 1975 42884

Deretter den andre listen:

``` r
head(tabell[[2]])
```

      ContentsCode  Tid value
    1          BNP 1970 23616
    2          BNP 1971 26363
    3          BNP 1972 29078
    4          BNP 1973 32805
    5          BNP 1974 37734
    6          BNP 1975 42884

Vi ser at det er litt ulike variabelnavn og variabelbenevnelser mellom
de to listene. I begge tilfellene ser vi at dataene på år er registrert
som tegn (`<chr>`). Dette må vi gjøre om til numeriske (`<int>`)
verdier.

Vi lagrer den første listen som et data objekt vi kaller `bnp`:

``` r
bnp <- tabell[[1]]
str(bnp)
```

    'data.frame':   50 obs. of  3 variables:
     $ statistikkvariabel: chr  "Bruttonasjonalprodukt" "Bruttonasjonalprodukt" "Bruttonasjonalprodukt" "Bruttonasjonalprodukt" ...
     $ år                : chr  "1970" "1971" "1972" "1973" ...
     $ value             : int  23616 26363 29078 32805 37734 42884 48711 54652 60091 66069 ...

Vi endrer år til numerisk, og endrer navn på bruttonasjonalprodukt fra
`value` til `BNP`:

``` r
bnp <- bnp %>%
  mutate(år=parse_number(år)) %>% 
  rename(BNP=value)
str(bnp)
```

    'data.frame':   50 obs. of  3 variables:
     $ statistikkvariabel: chr  "Bruttonasjonalprodukt" "Bruttonasjonalprodukt" "Bruttonasjonalprodukt" "Bruttonasjonalprodukt" ...
     $ år                : num  1970 1971 1972 1973 1974 ...
     $ BNP               : int  23616 26363 29078 32805 37734 42884 48711 54652 60091 66069 ...

``` r
head(bnp)
```

         statistikkvariabel   år   BNP
    1 Bruttonasjonalprodukt 1970 23616
    2 Bruttonasjonalprodukt 1971 26363
    3 Bruttonasjonalprodukt 1972 29078
    4 Bruttonasjonalprodukt 1973 32805
    5 Bruttonasjonalprodukt 1974 37734
    6 Bruttonasjonalprodukt 1975 42884

Deretter lager vi et enkelt “default” plot:

``` r
bnp %>%
  ggplot(aes(x=år, y=BNP)) +
  geom_line()
```

![](case_1_bnp_to_github_files/figure-markdown_github/unnamed-chunk-9-1.png)

Vi kan enkelt forbedre litt på fremstillingen, som f.eks:

``` r
bnp %>%
  ggplot(aes(x=år, y=BNP)) +
  geom_line(color="dark blue") +
  scale_y_continuous(labels = scales::comma) +
  labs(title="Bruttonasjonalprodukt - BNP \n (kr per innbygger)",
       x =" ",
       y = "kr per innbygger") +
  theme_bw()
```

![](case_1_bnp_to_github_files/figure-markdown_github/unnamed-chunk-10-1.png)

#### Oppgave 1

Drøft hvilke endringer som er gjort når du sammenligner de to
bruttonasjonalprodukt figurene.

#### Oppgave 2

Lag en ny figur der du denne gangen kun benytter BNP tall fra og med
1990.

Hint: benytt `dplyr::filter()` funksjonen.

### Hvordan måle endringer?

Logaritmer er eksponenter. La *x* = *b*<sup>*n*</sup>, da vil *n* være
logaritmen til *x* med grunntall *b*. Det irrasjonelle tallet *e*≅
2.7182818 blir brukt i matematikk, statistikk og økonomi som grunntall
for logaritmer. Vi kaller logaritmer med *e* som grunntall for naturlige
logaritmer. Vi utrykker den naturlige logaritmen av *x* som ln (*x*). I
`R` så benyttes funksjonen `log()` for den naturlige logaritmen, og
`exp()` for eksponentialfunksjonen.

For ethvert positiv tall, *x* \> 0, har vi:

*e*<sup>ln (*x*)</sup> = `exp`\[ln(*x*)\] = *x*
og

ln (*e*<sup>*x*</sup>) = *x*

En endring i en variabel *x* mellom to verdier, fra *x*<sub>0</sub>
(start) til *x*<sub>1</sub> (stopp) kalles differansen △*x*. Ettersom
△*x* = *x*<sub>1</sub> − *x*<sub>0</sub> blir den relative endringen i
*x* lik:

$$\\texttt{relativ endring i } x=\\frac{x_1 - x_0}{x_0}=\\frac{\\triangle x}{x_0}$$

Er for eksempel *x*<sub>0</sub> = 5 og *x*<sub>1</sub> = 5.3, blir den
relative endringen i *x* lik:

$$\\frac{x_1 - x_0}{x_0}=\\frac{5.3-5}{5}=0.06$$

Som oftest så benytter vi bare notasjonen △*x*/*x*. Den relative
endringen er et desimaltall. Den korresponderende prosentvise endringen
i *x* er 100 ganger den relative endringen.

$$\\texttt{prosentvis endring i } x=100 \\times \\frac{x_1 - x_0}{x_0}=\\% \\triangle x$$

Er for eksempel *x*<sub>0</sub> = 5 og *x*<sub>1</sub> = 5.3, blir den
prosentvise endringen i *x* lik:

$$\\% \\triangle x=100 \\times \\frac{x_1 - x_0}{x_0}=100 \\times \\frac{5.3-5}{5}=6 \\%$$

### Logaritmer og prosenter

En egenskap med logaritmer, og som gjør dem svært populære blant
økonomer er følgende tolkning. La *x*<sub>1</sub> være en positiv verdi
av *x*, og la *x*<sub>0</sub> være en verdi av *x* som er “nær”
*x*<sub>1</sub>. Vi kan da si at:

100 × \[ln(*x*<sub>1</sub>)−ln(*x*<sub>0</sub>)\] ≅ %△*x* = `prosentvis endring i `*x*

Så 100 ganger differansen mellom logaritmen til *x*<sub>1</sub> og
*x*<sub>0</sub> er *tilnærmet* lik den prosentvise forskjellen mellom de
to verdiene av *x*, forutsatt at de to verdiene av *x* ikke er langt
unna hverandre.

Er for eksempel *x*<sub>0</sub> = 5 og *x*<sub>1</sub> = 5.3, blir den
prosentvise endringen i *x* lik:

100 × \[ln(5.3)−ln(5)\] = 5.83%

### Endringer i BNP

Våre *B**N**P* data er tidsseriedata, der årstallet bestemmer
rekkefølgen. For å beregne differansen △*x* på tidsserier indekserer vi
dem med tid (*t*). En endring i en tidsserievariabel *x*<sub>*t*</sub>
mellom to tidspunkt, fra *x*<sub>*t*</sub> (denne periode) til
*x*<sub>*t* − 1</sub> (forrige periode) er
△*x*<sub>*t*</sub> = *x*<sub>*t*</sub> − *x*<sub>*t* − 1</sub>. I `R` så
benyttes funksjonen `lag()` for å tidsforskyve en variabel en periode
(*x*<sub>*t* − 1</sub>).

Vi gjør dette på våre `bnp` data, og kaller den nye variabelen
*B**N**P*<sub>*t* − 1</sub> for `BNP_L1`.

``` r
bnp %>% 
  mutate(BNP_L1=lag(BNP)) %>% 
  head()
```

         statistikkvariabel   år   BNP BNP_L1
    1 Bruttonasjonalprodukt 1970 23616     NA
    2 Bruttonasjonalprodukt 1971 26363  23616
    3 Bruttonasjonalprodukt 1972 29078  26363
    4 Bruttonasjonalprodukt 1973 32805  29078
    5 Bruttonasjonalprodukt 1974 37734  32805
    6 Bruttonasjonalprodukt 1975 42884  37734

Vi ser at den første verdien for tidsforskjøvet BNP mangler (*NA*). Vi
kan nå fortsette med å beregne differansen i *B**N**P*.

``` r
bnp %>% 
  mutate(BNP_L1=lag(BNP),
         dBNP=BNP-BNP_L1) %>% 
  head()
```

         statistikkvariabel   år   BNP BNP_L1 dBNP
    1 Bruttonasjonalprodukt 1970 23616     NA   NA
    2 Bruttonasjonalprodukt 1971 26363  23616 2747
    3 Bruttonasjonalprodukt 1972 29078  26363 2715
    4 Bruttonasjonalprodukt 1973 32805  29078 3727
    5 Bruttonasjonalprodukt 1974 37734  32805 4929
    6 Bruttonasjonalprodukt 1975 42884  37734 5150

Vi kan selvsagt gjøre beregningen av differansen direkte.

``` r
bnp %>% 
  mutate(dBNP=BNP-lag(BNP)) %>% 
  head()
```

         statistikkvariabel   år   BNP dBNP
    1 Bruttonasjonalprodukt 1970 23616   NA
    2 Bruttonasjonalprodukt 1971 26363 2747
    3 Bruttonasjonalprodukt 1972 29078 2715
    4 Bruttonasjonalprodukt 1973 32805 3727
    5 Bruttonasjonalprodukt 1974 37734 4929
    6 Bruttonasjonalprodukt 1975 42884 5150

Den prosentvise endringen i *B**N**P* blir.

``` r
bnp %>%
  mutate(prosBNP = 100*(BNP - lag(BNP))/lag(BNP)) %>%
  head()
```

         statistikkvariabel   år   BNP  prosBNP
    1 Bruttonasjonalprodukt 1970 23616       NA
    2 Bruttonasjonalprodukt 1971 26363 11.63194
    3 Bruttonasjonalprodukt 1972 29078 10.29852
    4 Bruttonasjonalprodukt 1973 32805 12.81725
    5 Bruttonasjonalprodukt 1974 37734 15.02515
    6 Bruttonasjonalprodukt 1975 42884 13.64817

Vi kan lage en enkel figur av de prosentvise endringen. Legg merke til
at vi får en feilmelding fordi vi mangler den første observasjonen.

``` r
bnp %>%
  mutate(prosBNP = 100*(BNP - lag(BNP))/lag(BNP)) %>%
  ggplot(aes(x=år, y=prosBNP)) +
  geom_line()
```

    Warning: Removed 1 row(s) containing missing values (geom_path).

![](case_1_bnp_to_github_files/figure-markdown_github/unnamed-chunk-15-1.png)

Vi fjerner den manglende observasjonen, og forbedrer litt på
fremstillingen.

``` r
bnp %>%
  mutate(prosBNP = 100*(BNP - lag(BNP))/lag(BNP)) %>%
  filter(år >=1971) %>% 
  ggplot(aes(x=år, y=prosBNP)) +
  geom_line(color="dark red") +
  labs(title="Prosentvis endring i bruttonasjonalprodukt - BNP",
       x =" ",
       y = "prosent") +
  theme_bw()
```

![](case_1_bnp_to_github_files/figure-markdown_github/unnamed-chunk-16-1.png)

#### Oppgave 3

Drøft hvilke endringer som er gjort når du sammenligner de to figurene
med prosentvis endring i bruttonasjonalprodukt.

#### Oppgave 4

Lag en ny figur der du denne gangen benytter formelen for det
logaritmiske differensialet for å beregne prosentvis endring i
bruttonasjonalprodukt.

#### Oppgave 5

Hvilket år har vi den største årlige nedgangen, og hvorfor?

Hint: Vi kan sortere de prosentvise endringen med å benytte en bestemt
funksjon. Gjør et google søk på “r dplyr sort”, benytt denne funksjonen
til å ferdigstille koden under.

``` r
bnp %>%
  mutate(prosBNP = 100*(BNP - lag(BNP))/lag(BNP)) %>%
  filter(år >=1971) %>% 
  ___(prosBNP)
```

#### Oppgave 6

Vi kan også gjøre en litt mer avansert analyse ved å beregne
gjennomsnittet av de prosentvise endringen i bruttonasjonalprodukt per
tiår. Drøft det som er gjort i koden, og kommenter det du ser i figuren.

``` r
bnp %>%
  mutate(prosBNP = 100*(BNP - lag(BNP))/lag(BNP)) %>%
  filter(år >=1971) %>%
  mutate(tiår = år - år %% 10) %>%
  group_by(tiår) %>% 
  mutate(snittBNP=mean(prosBNP)) %>%
  ggplot(aes(x=år)) +
  geom_line(aes(y=prosBNP), color="dark red") +
  geom_step(aes(y=snittBNP), color="steelblue", linetype="dashed") +
  labs(title="Prosentvis endring i bruttonasjonalprodukt - BNP \n (gjennomsnitt per tiår)",
       x=" ",
       y="prosent") +
  theme_bw()
```

![](case_1_bnp_to_github_files/figure-markdown_github/unnamed-chunk-18-1.png)

## `R` kode fra dette caset

``` r
getwd()
setwd("~/undervisning/okemnprog")
knitr::purl("case_1_bnp.Rmd")
```
