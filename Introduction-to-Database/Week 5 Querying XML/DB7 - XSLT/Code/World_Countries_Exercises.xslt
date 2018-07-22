<!-- XML World-Countries XSLT Exercises -->

<!--*******************************************************************************
     Q1. Return all countries with population between 9 and 10 million. 
         Retain the structure of country elements from the original data. 
********************************************************************************-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="countries/country[@population &gt; 9000000 and @population &lt; 10000000]">
    <xsl:copy-of select = "." />
</xsl:template>

<xsl:template match="text()" />

</xsl:stylesheet>


<!--*******************************************************************************
     Q2. Create a table using HTML constructs that lists all countries that have 
     more than 3 languages. Each row should contain the country name in bold, 
     population, area, and number of languages. Sort the rows in descending 
     order of number of languages. No header is needed for the table, but use 
     <table border="1"> to make it format nicely, should you choose to check
      your result in a browser. (Hint: You may find the data-type and order 
      attributes of <xsl:sort> to be useful.) 
********************************************************************************-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
   <!-- Without <html> the output will be shown in one line  -->
   <!-- <html> helps for better output formatting  -->
   <html>  
   <table border="1">
      <!--********* With head ********* 
      <th>Name</th>
      <th>Population</th>
      <th>Area</th>
      <th>Number of Languages</th>
      ******************************-->
      <xsl:for-each select="countries/country[count(language) &gt; 3]">
      <xsl:sort select="count(language)" order="descending"/>
         <tr>
         <td><b> <xsl:value-of select="data(@name)" /> </b></td>
         <td> <xsl:value-of select="data(@population)" /> </td>
         <td> <xsl:value-of select="data(@area)" /> </td>
         <td> <xsl:value-of select="count(language)" /> </td>
         </tr>
      </xsl:for-each>
   </table>
   </html>
</xsl:template>

<xsl:template match='text()' />

</xsl:stylesheet>


<!--*******************************************************************************
     Q3. Create an alternate version of the countries database: for each country, 
     include its name and population as sublements, and the number of languages 
     and number of cities as attributes (called "languages" and "cities" respectively). 
********************************************************************************-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="*|@*|text()">
   <xsl:copy>
      <xsl:apply-templates select="*|@*|text()" />
   </xsl:copy>
</xsl:template>

<xsl:template match="country">
    <country languages = "{count(language)}"
             cities = "{count(city)}" >         
      <name> <xsl:value-of select = "data(@name)" /> </name>
      <population> <xsl:value-of select = "data(@population)" /> </population>
    </country>
</xsl:template>

</xsl:stylesheet>

<!------- Alternative (especially for the recursive part) ------->

<xsl:template match="/">
   <countries>
      <xsl:apply-templates select="*|@*|text()" />
   </countries>
</xsl:template>

<!------- Alternative (especially for the recursive part) ------->

<xsl:template match="/">
   <countries>
      <xsl:apply-templates />
   </countries>
</xsl:template>


<!-- XML World-Countries XSLT Exercises Extras -->

<!--*******************************************************************************
     Q1. Find all country names containing the string "stan"; 
         return each one within a "Stan" element. 
********************************************************************************-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="countries/country[contains(@name, 'stan')]">
    <Stan> <xsl:copy-of select = "data(@name)" /> </Stan>
</xsl:template>

<xsl:template match="text()" />


</xsl:stylesheet>

<!--*******************************************************************************
     Q2. Remove from the data all countries with area greater than 40,000 and 
         all countries with no cities listed. Otherwise the structure of 
         the data should be the same. 
********************************************************************************-->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
   <countries>
     <xsl:for-each select = "countries/country[@area &lt; 40001 and count(city) &gt; 0]">
       <xsl:copy-of select="." />
     </xsl:for-each>
   </countries>
</xsl:template>

<xsl:template match="text()" />

</xsl:stylesheet>

<!----- Wrong answer as it doesn't produce <countries> at the outermost side ----->

<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="countries/country[@area &lt; 40001 and count(city) &gt; 0]">
     <xsl:copy-of select="." />
</xsl:template>

<xsl:template match="text()" />

</xsl:stylesheet>