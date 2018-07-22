(:***************************************************************
   Helpful website for XQuery Command
   http://www.datypic.com/books/xquery/chapter05.html
****************************************************************:)

      (:=== XML World-Countries XPath and XQuery Exercises ===:)

(:***************************************************************
   Q1. Return the area of Mongolia. 
****************************************************************:)

doc("../countries.xml")/countries/country[@name = "Mongolia"]/data(@area)

(:***************************************************************
   Q2. Return the names of all cities that have the same name 
       as the country in which they are located. 
****************************************************************:)

doc("../countries.xml")/countries/country/city[name = parent::*/@name]/name

(:=== It returns different style but the result is correct ===:)

doc("../countries.xml")/countries/country[@name = city/name]/data(@name)

(:***************************************************************
   Q3. Return the average population of Russian-speaking countries. 
****************************************************************:)

avg(doc("../countries.xml")/countries/country[language = "Russian"]/@population)

(:***************************************************************
   Q4. Return the names of all countries that have at least 
       three cities with population greater than 3 million. 
****************************************************************:)

doc("../countries.xml")/countries/country[
    count(city[population > 3000000]) > 2]/data(@name)

(:***************************************************************
   Q5. Create a list of French-speaking and German-speaking 
       countries. The result should take the form:
****************************************************************:)      

<result>
   <French>
   { for $c in doc("../countries.xml")/countries/country[count(language) > 0]
     where $c/language = "French"
     return <country> { $c/data(@name) } </country> }
   </French>   

   <German>
   { for $c in doc("../countries.xml")/countries/country[count(language) > 0]
     where $c/language = "German"
     return <country> { $c/data(@name) } </country> }
   </German>      
</result>

(:***************************************************************
   Q6. Return the countries with the highest and lowest population 
   densities. Note that because the "/" operator has its own 
   meaning in XPath and XQuery, the division operator is infix "div". 
   To compute population density use "(@population div @area)". 
   You can assume density values are unique.
****************************************************************:)        

<result>
   <highest density="{max(doc("../countries.xml")/countries/country/data(@population div @area))}" >  
   { let $counts := doc("../countries.xml")//country
     return $counts[@population div @area = 
                      max($counts/data(@population div @area))]/data(@name) }
   </highest>   
   <lowest density="{min(doc("../countries.xml")/countries/country/data(@population div @area))}" >   
   { let $counts := doc("../countries.xml")//country
     return $counts[@population div @area = 
                      min($counts/data(@population div @area))]/data(@name) }   
   </lowest>
</result>


      (:=== XML World-Countries XPath and XQuery Exercises Extras ===:)

(:***************************************************************
   Q1. Return the names of all countries with population 
       greater than 100 million. 
****************************************************************:)

doc("../countries.xml")/countries/country[@population > 100000000]/data(@name)

(:***************************************************************
   Q2. Return the names of all countries where over 50% of the 
   population speaks German. (Hint: Depending on your solution, 
   you may want to use ".", which refers to the "current element" 
   within an XPath expression.) 
****************************************************************:)

for $c in doc("../countries.xml")/countries/country
where $c[language = "German"]/language/data(@percentage) > 50
return $c/data(@name)
     
(:=== Alternative ===:)

let $countries := doc("../countries.xml")/countries/country
return $countries//language[data(.) = 'German' and @percentage > 50]/parent::country/data(@name)

(:***************************************************************
   Q3. Return the names of all countries where a city in that country 
   contains more than one-third of the country's population. 
****************************************************************:)

for $c in doc("../countries.xml")/countries/country
where $c//city/population > ($c/@population div 3)
return $c/data(@name)

(:=== Alternative ===:)

let $c := doc("../countries.xml")/countries/country
return $c[city/population > (@population div 3)]/data(@name)

(:***************************************************************
   Q4. Return the population density of Qatar.
****************************************************************:)            

doc("../countries.xml")/countries/country[@name = "Qatar"]/(@population div @area)     

(:***************************************************************
   Q5. Return the names of all countries whose population is 
   less than one thousandth that of some city (in any country). 
****************************************************************:)                     

let $countries := doc("../countries.xml")/countries/country
for $c in $countries
where some $citypop in $countries/city/population 
      satisfies $c/@population < ($citypop div 1000)
return $c/data(@name)

(:***************************************************************
   Q6. Return all city names that appear more than once, i.e., 
   there is more than one city with that name in the data. 
   Return only one instance of each such city name.
****************************************************************:)  

let $cities := doc("../countries.xml")/countries/country/city
return $cities[name = following::*/name]/name

(:=== Alternative ===:)

doc("../countries.xml")/countries/country/city[name = preceding::*/name]/name

(:***************************************************************
   Q7. Return the names of all countries containing a city 
   such that some other country has a city of the same name. 
****************************************************************:) 

let $countries := doc("../countries.xml")/countries/country
return $countries[city/name = following::city/name or 
                  city/name = preceding::city/name]/data(@name)


(:***************************************************************
   Q8. Return the names of all countries whose name textually 
   contains a language spoken in that country. For instance, 
   Uzbek is spoken in Uzbekistan, so return Uzbekistan.
****************************************************************:) 

for $c in doc("../countries.xml")/countries/country
where some $lang in $c/language/. satisfies contains($c/@name, $lang)
return $c/data(@name)

(:***************************************************************
   Q9. Return the names of all countries in which people speak a 
   language whose name textually contains the name of the country. 
   For instance, Japanese is spoken in Japan, so return Japan.
****************************************************************:) 

for $c in doc("../countries.xml")/countries/country
where some $lang in $c/language/. satisfies contains($lang, $c/@name) 
return $c/data(@name)

(:***************************************************************
   Q10. Return all languages spoken in a country whose name 
   textually contains the language name. For instance, German 
   is spoken in Germany, so return German.
****************************************************************:) 

for $c in doc("../countries.xml")/countries/country
for $lang in $c/language/.
return distinct-values($lang[contains($c/@name, $lang)])

(:***************************************************************
   Q11. Return all languages whose name textually contains the 
   name of a country in which the language is spoken. For instance, 
   Icelandic is spoken in Iceland, so return Icelandic.
****************************************************************:) 

for $c in doc("../countries.xml")/countries/country
for $lang in $c/language/.
return distinct-values($lang[contains($lang, $c/@name)]) 

(:***************************************************************
   Q12. Return the number of countries where Russian is spoken. 
****************************************************************:) 

count(doc("../countries.xml")/countries/country[language = "Russian"])

(:***************************************************************
   Q13. Return the names of all countries for which the data 
   does not include any languages or cities, but the country 
   has more than 10 million people. 
****************************************************************:) 

doc("../countries.xml")/countries/country[count(language) = 0 and 
          count(city) = 0 and @population > 10000000]/data(@name)

(:***************************************************************
   Q14. Return the name of the country with the highest population.
****************************************************************:) 

doc("../countries.xml")/countries/country[@population = 
      max(doc("../countries.xml")/countries/country/@population)]/data(@name)

(:***************************************************************
   Q15. Return the name of the country that has the city 
        with the highest population.
****************************************************************:) 

doc("../countries.xml")/countries/country[city/population = 
      max(doc("../countries.xml")/countries/country/city/population)]/data(@name)

(:***************************************************************
   Q16. Return the average number of languages spoken 
        in countries where Russian is spoken. 
****************************************************************:)            

let $Rus_cout := doc("../countries.xml")/countries/country[language = "Russian"]
return count($Rus_cout/language) div count($Rus_cout)

(:***************************************************************
   Q17. Return all country-language pairs where the language is 
   spoken in the country and the name of the country textually 
   contains the language name. Return each pair as a country 
   element with language attribute, e.g.,
   <country language="French">French Guiana</country>
****************************************************************:) 

for $c in doc("../countries.xml")/countries/country
for $lang in $c/language/.
where contains($c/@name, $lang)
return  <country language="{ $lang }">  { $c/data(@name) } </country>

(:***************************************************************
   Q18. Return all countries that have at least one city with 
   population greater than 7 million. For each one, return 
   the country name along with the cities greater than 7 million 
****************************************************************:) 

for $c in doc("../countries.xml")/countries/country[city/population > 7000000]
return <country> 
         { $c/@name }  
         { for $city in $c/city[population > 7000000]
           return <big> { $city/data(name) } </big> }        
       </country>
(:== Remember to use data(name), otherwise the result is wrong ==:)       

(:***************************************************************
   Q19. Return all countries where at least one language is listed, 
   but the total percentage for all listed languages is less than 90%. 
   Return the country element with its name attribute and its 
   language subelements, but no other attributes or subelements.
****************************************************************:) 

for $c in doc("../countries.xml")/countries/country[
                 count(language) > 0 and sum(language/@percentage) < 90]
return <country>  { $c/@name}   { $c/language } </country>    

(:***************************************************************
   Q20. Return all countries where at least one language is listed, 
   and every listed language is spoken by less than 20% of the 
   population. Return the country element with its name attribute 
   and its language subelements, but no other attributes or subelements. 
****************************************************************:) 

for $c in doc("../countries.xml")/countries/country[count(language) > 0]
where every $perc in $c/language/@percentage satisfies $perc < 20
return <country>  { $c/@name}   { $c/language } </country>  

(:***************************************************************
   Q21. Find all situations where one country's most popular 
   language is another country's least popular, and both countries 
   list more than one language. (Hint: You may need to explicitly 
   cast percentages as floating-point numbers with xs:float() to 
   get the correct answer.) Return the name of the language and 
   the two countries, each in the format:
****************************************************************:) 

for $c1 in doc("../countries.xml")/countries/country[count(language) > 1]
for $c2 in doc("../countries.xml")/countries/country[count(language) > 1]
where $c1/language[@percentage = max($c1/language/@percentage)]/data(.) = 
      $c2/language[@percentage = min($c2/language/@percentage)]/data(.)
return <LangPair language="{$c1/language[@percentage = max($c1/language/@percentage)]/data(.)}">
          <MostPopular> { $c1/data(@name) } </MostPopular>
          <LeastPopular> { $c2/data(@name) } </LeastPopular>
       </LangPair>

(:***************************************************************
   Q22. For each language spoken in one or more countries, 
   create a "language" element with a "name" attribute and one 
   "country" subelement for each country in which the language is 
   spoken. The "country" subelements should have two attributes: 
   the country "name", and "speakers" containing the number of 
   speakers of that language (based on language percentage and 
   the country's population). Order the result by language name, 
   and enclose the entire list in a single "languages" element. 
****************************************************************:) 

<languages>
  { for $lang in distinct-values(doc("../countries.xml")/countries/country/language/data(.))
    order by $lang
    return 
       <language name="{$lang}">
       { for $country in doc("../countries.xml")/countries/country[language = $lang] 
         return <country name="{$country/@name}" 
                         speakers="{xs:int($country/@population * 
                            $country/language[data(.) = $lang]/@percentage div 100)}">        
                </country>
       }
       </language>
  }
</languages>