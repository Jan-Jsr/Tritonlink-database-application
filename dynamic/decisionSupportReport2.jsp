
<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="Index.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql://localhost:5432/cse132b?user=postgres&password=Tswhy/569";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>

           

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                conn.setAutoCommit(false);
                Statement statement1 = conn.createStatement();
                Statement statement2 = conn.createStatement();
                Statement statement_avg = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.

                ResultSet rs1 = null;
                ResultSet rs2 = null;
                //ResultSet rs_avg = null;
                if (!request.getParameter("quarter").equals("Any")) {
                    rs1 = statement1.executeQuery("Select grade, count from cpqg where course_id = '"+ request.getParameter("course_id") +"' and quarter = '"+ request.getParameter("quarter") +"' and faculty = '"+ request.getParameter("faculty") +"' and (grade = 'A' or grade = 'B' or grade = 'C' or grade = 'D')");
                    rs2 = statement2.executeQuery("Select sum(count) from cpqg where course_id = '"+ request.getParameter("course_id") +"' and quarter = '"+ request.getParameter("quarter") +"' and faculty = '"+ request.getParameter("faculty") +"' and (grade != 'A' and grade != 'B' and grade != 'C' and grade != 'D')");
                }


                if (request.getParameter("quarter").equals("Any") && !request.getParameter("faculty").equals("Any")) {
                    rs1 = statement1.executeQuery("Select grade, count from cpg where course_id = '"+ request.getParameter("course_id") +"' and faculty = '"+ request.getParameter("faculty") +"' and (grade = 'A' or grade = 'B' or grade = 'C' or grade = 'D')");
 					rs2 = statement2.executeQuery("Select sum(count) from cpg where course_id = '"+ request.getParameter("course_id") +"' and faculty = '"+ request.getParameter("faculty") +"' and (grade != 'A' and grade != 'B' and grade != 'C' and grade != 'D')");
                   //rs_avg = statement_avg.executeQuery("Select avg(tmp.gpa) as avg from (learning INNER JOIN section on learning.section_id = section.id) as tmp where exists(select * from class c where tmp.class = c.id and c.course_id = " + request.getParameter("course_id") + ") and tmp.faculty = '" +request.getParameter("faculty") + "'");
                }
                    

                
       
                conn.commit();
                conn.setAutoCommit(true);


            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>COUNT</th>
                        <th>GRADE</th>
                    </tr>
                  

            <%

                while (rs1.next()) {

            %>


                    <tr>
                        <th><input value="<%= rs1.getString("count") %>" name="count" size="10" readonly></th>
                        <th><input value="<%= rs1.getString("grade") %>" name="grade" size="10" readonly></th>
                    </tr>

            <%
               } 
            
            while (rs2.next()) {

                %>


                        <tr>
                            <th><input value="<%= rs2.getString("sum") %>" name="sum" size="10" readonly></th>
                            <th><input value="other" name="grade" size="10" readonly></th>
                        </tr>

                <%
                   } 
            
           
	
               
            %>
          

                </table>

            <%-- -------- Close Connection Code -------- --%>
            <%

                    rs1.close();
            		rs2.close();
                    statement1.close();
                    statement2.close();
                   
                    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
            </td>
        </tr>
    </table>
</body>

</html>