
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
                    conn.setAutoCommit(false);
            %>
			 <form action="Report_3_2_rebuild.jsp" method="get">
                <select name="quarter">

            <%

                Statement statement1 = conn.createStatement();
                ResultSet rs1 = statement1.executeQuery("Select distinct quarter from cpqg");



                while(rs1.next()) {


            %>
                <option value="<%= rs1.getString("quarter") %>"><%= rs1.getString("quarter") %></option>
            <%
                }
            %>
                </select>


                <select name="course_id">

            <%

                Statement statement2 = conn.createStatement();
                ResultSet rs2 = statement2.executeQuery("Select distinct course_id from cpqg");




                while(rs2.next()) {


            %>
                <option value="<%= rs2.getString("course_id") %>"><%= rs2.getString("course_id") %></option>
            <%
                }
            %>
                </select>

                <select name="faculty">



            <%
                Statement statement3 = conn.createStatement();
                ResultSet rs3 = statement3.executeQuery("Select distinct faculty from cpqg");  //没有加where name = “professor”因为前面定义：The word "professor" refers to any faculty member and not just those with TITLE equal to 'PROFESSOR'.


                while(rs3.next()) {
            %>

                <option value="<%= rs3.getString("faculty") %>"><%= rs3.getString("faculty") %></option>
            <%
                }
            %>
                </select>



                
           

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
             
                Statement statement4 = conn.createStatement();
                Statement statement5 = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.

                ResultSet rs4 = null;
                ResultSet rs5 = null;
        
                rs4 = statement4.executeQuery("Select grade, count from cpqg where course_id = '"+ request.getParameter("course_id") +"' and quarter = '"+ request.getParameter("quarter") +"' and faculty = '"+ request.getParameter("faculty") +"' and (grade = 'A' or grade = 'B' or grade = 'C' or grade = 'D')");
                rs5 = statement5.executeQuery("Select grade, count from cpqg where course_id = '"+ request.getParameter("course_id") +"' and quarter = '"+ request.getParameter("quarter") +"' and faculty = '"+ request.getParameter("faculty") +"' and (grade != 'A' and grade != 'B' and grade != 'C' and grade != 'D')");


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

                while (rs4.next()) {

            %>


                    <tr>
                        <th><input value="<%= rs4.getString("count") %>" name="count" size="10" readonly></th>
                        <th><input value="<%= rs4.getString("grade") %>" name="grade" size="10" readonly></th>
                    </tr>

            <%
               } 
				
            while (rs5.next()) {

                %>


                        <tr>
                            <th><input value="<%= rs5.getString("count") %>" name="count" size="10" readonly></th>
                            <th><input value="<%= rs5.getString("grade") %>" name="grade" size="10" readonly></th>
                        </tr>

                <%
                   } 
              
            %>

                </table>
            <th><input type="submit" value="decision support"></th>
             </tr>
            </form>

            <%-- -------- Close Connection Code -------- --%>
            <%

            
            rs1.close();
            rs2.close();
            rs3.close();
            // Close the Statement
            statement1.close();
            statement2.close();
            statement3.close();
            
                    rs4.close();
                    statement4.close();
                    rs5.close();
                    statement5.close();
                   
                    
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