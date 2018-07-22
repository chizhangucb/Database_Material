      (:=== XML Course-Catalog XPath and XQuery Exercises ===:)

(:***************************************************************
   Q1. Return all Title elements (of both departments and courses)
****************************************************************:)

doc("../Stanford_courses_noID.xml")/Course_Catalog//Title

(:***************************************************************
   Q2. Return last names of all department chairs
****************************************************************:)

doc("../Stanford_courses_noID.xml")/Course_Catalog/Department/Chair//Last_Name

(:***************************************************************
   Q3. Return titles of courses with enrollment greater than 500
****************************************************************:)

doc("../Stanford_courses_noID.xml")/Course_Catalog/Department/Course[@Enrollment > 500]/Title

(:***************************************************************
   Q4. Return titles of departments that have some course 
       that takes "CS106B" as a prerequisite. 
****************************************************************:)

doc("../Stanford_courses_noID.xml")/Course_Catalog/Department[
       count(Course[contains(Prerequisites, "CS106B")]) > 0 ]/Title

(:***************************************************************
   Q5. Return last names of all professors or lecturers who use 
   a middle initial. Don't worry about eliminating duplicates. 
****************************************************************:)      

doc("../Stanford_courses_noID.xml")//(Chair | Instructors)/*[
    boolean(Middle_Initial) ]/Last_Name

(:***************************************************************
   Q6. Return the count of courses that have a cross-listed course 
   (i.e., that have "Cross-listed" in their description). 
****************************************************************:)        

count(doc("../Stanford_courses_noID.xml")/Course_Catalog/Department/
                      Course[contains(Description, "Cross-listed")])

(:***************************************************************
   Q7. Return the average enrollment of all courses in the CS department. 
****************************************************************:)        

avg(doc("../Stanford_courses_noID.xml")/Course_Catalog/
         Department[@Code = "CS"]/Course/data(@Enrollment))

(:***************************************************************
   Q8. Return last names of instructors teaching at least 
       one course that has "system" in its description and 
       enrollment greater than 100. 
****************************************************************:)                

doc("../Stanford_courses_noID.xml")//Course[@Enrollment > 100 and 
         ontains(Description, "system")]/Instructors/*/Last_Name

(:***************************************************************
   Q9. Return the title of the course with the largest enrollment. 
****************************************************************:)         

for $c1 in doc("../Stanford_courses_noID.xml")//Course
where $c1/@Enrollment = 
      max(doc("../Stanford_courses_noID.xml")//Course/data(@Enrollment))
return $c1/Title    

(:=== Alternative Method ===:)

doc("../Stanford_courses_noID.xml")//Course[data(@Enrollment)[
    not(. > doc("../Stanford_courses_noID.xml")//Course/data(@Enrollment))]]/Title



      (:=== XML Course-Catalog XPath and XQuery Exercises Extras ===:)

(:***************************************************************
   Q1. Return the course number of the course that is 
       cross-listed as "LING180". 
****************************************************************:)

doc("../Stanford_courses_noID.xml")/Course_Catalog/Department/Course[
          contains(Description, "Cross-listed") and 
          contains(Description, "LING180")]/data(@Number)

(:***************************************************************
   Q2. Return course numbers of courses that have the same title 
       as some other course. (Hint: You might want to use the 
       "preceding" and "following" navigation axes for this query, 
       which were not covered in the video or our demo script; 
       they match any preceding or following node, not just siblings.) 
****************************************************************:)

doc("../Stanford_courses_noID.xml")/Course_Catalog/Department/Course[
            Title = following::*/Title or
            Title = preceding::*/Title]/data(@Number)          

(:***************************************************************
   Q3. Return course numbers of courses taught by an instructor 
       with first name "Daphne" or "Julie". 
****************************************************************:)

doc("../Stanford_courses_noID.xml")/Course_Catalog/Department/Course[
            Instructors/*/First_Name = "Daphne" or 
            Instructors/*/First_Name = "Julie"]/data(@Number)          

(:***************************************************************
   Q4. Return the number (count) of courses that have 
       no lecturers as instructors. 
****************************************************************:)            

count(doc("../Stanford_courses_noID.xml")//Course[
            count(Instructors/Lecturer) = 0])          

(:***************************************************************
   Q5. Return titles of courses taught by the chair of a department. 
       For this question, you may assume that all professors have 
       distinct last names. 
****************************************************************:)                     

let $ch := doc("../Stanford_courses_noID.xml")/Course_Catalog/Department/Chair
for $c in doc("../Stanford_courses_noID.xml")/Course_Catalog/Department/Course
where $c/Instructors/*/Last_Name = $ch/*/Last_Name
return $c/Title

(:***************************************************************
   Q6. Return titles of courses that have both a lecturer and
       a professor as instructors. Return each title only once. 
****************************************************************:)  

doc("../Stanford_courses_noID.xml")//Course[
    count(Instructors/Professor) > 0 and 
    count(Instructors/Lecturer) > 0]/Title

(:***************************************************************
   Q7. Return titles of courses taught by a professor with the 
   last name "Ng" but not by a professor with the last name "Thrun". 
****************************************************************:) 

doc("../Stanford_courses_noID.xml")//Course[
    Instructors/Professor/Last_Name = "Ng" and
    count(Instructors/Professor[Last_Name = "Thrun"]) = 0]/Title

(:***************************************************************
   Q8. Return course numbers of courses that have a course 
       taught by Eric Roberts as a prerequisite. 
****************************************************************:) 

for $c in doc("../Stanford_courses_noID.xml")/Course_Catalog/Department/Course
for $prec in doc("../Stanford_courses_noID.xml")//Course[
            Instructors/*[First_Name = "Eric" and Last_Name = "Roberts"]]/data(@Number)
where $c/Prerequisites/Prereq = $prec            
return $c/data(@Number)

(:***************************************************************
   Q9. Create a summary of CS classes: List all CS department 
   courses in order of enrollment. For each course include only 
   its Enrollment (as an attribute) and its Title (as a subelement). 
****************************************************************:) 

<Summary>
{  for $c in doc("../Stanford_courses_noID.xml")//Department[@Code = "CS"]/Course
   order by xs:int($c/@Enrollment)
   return <Course>
             { $c/@Enrollment }
             { $c/Title }
          </Course> }
</Summary>       

(:***************************************************************
   Q10. Return a "Professors" element that contains as subelements 
   a listing of all professors in all departments, sorted by 
   last name with each professor appearing once. The "Professor" 
   subelements should have the same structure as in the original data. 
   For this question, you may assume that all professors have 
   distinct last names. Watch out -- the presence/absence of middle 
   initials may require some special handling.
****************************************************************:) 

<Professors>
{  for $ln in distinct-values(doc("../Stanford_courses_noID.xml")//Department/
                       (Chair | Course/Instructors)/Professor/Last_Name)
   for $fn in distinct-values(doc("../Stanford_courses_noID.xml")//Department/
                       (Chair | Course/Instructors)/Professor[Last_Name = $ln]/First_Name)
   order by $ln                                                        
   return <Professor>
             <First_Name> { $fn } </First_Name>
             { for $mn in distinct-values(doc("../Stanford_courses_noID.xml")//Department/
                       (Chair | Course/Instructors)/Professor[Last_Name = $ln and 
                                                              First_Name = $fn]/Middle_Initial) 
               return <Middle_Initial> { $mn } </Middle_Initial> } 
             <Last_Name> { $ln } </Last_Name>
          </Professor> }
</Professors>       

(:***************************************************************
   Q11. Expanding on the previous question, create an inverted 
   course listing: Return an "Inverted_Course_Catalog" element 
   that contains as subelements professors together with the 
   courses they teach, sorted by last name. You may still assume 
   that all professors have distinct last names. The "Professor" 
   subelements should have the same structure as in the original 
   data, with an additional single "Courses" subelement under 
   Professor, containing a further "Course" subelement for each 
   course number taught by that professor. Professors who do not 
   teach any courses should have no Courses subelement at all. 
****************************************************************:) 

<Inverted_Course_Catalog>
{  let $prof := doc("../Stanford_courses_noID.xml")//Professor
   for $ln in distinct-values($prof/Last_Name)
   for $fn in distinct-values($prof[Last_Name = $ln]/First_Name)
   let $courses := doc("../Stanford_courses_noID.xml")//Department/
                        Course[Instructors/Professor/Last_Name = $ln]
   order by $ln                                                        
   return <Professor>
             <First_Name> { $fn } </First_Name>
             { for $mn in distinct-values($prof[Last_Name = $ln and 
                                                First_Name = $fn]/Middle_Initial) 
               return <Middle_Initial> { $mn } </Middle_Initial> } 
             <Last_Name> { $ln } </Last_Name> 
             { if (exists($courses)) 
               then <Courses> 
                    {for $c in $courses
                     return <Course> { data($c/@Number) } </Course>} 
                    </Courses>        
               else () }
          </Professor> }
</Inverted_Course_Catalog>       