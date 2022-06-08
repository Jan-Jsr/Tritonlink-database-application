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
                    String dbURL = "jdbc:postgresql:cse132b?user=postgres&password=Tswhy/569";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO learnlist VALUES (?, ?, ?, ?, ?)");

                        
			            pstmt.setInt(1, Integer.parseInt(request.getParameter("stu_SSN")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("course_id")));
                        pstmt.setString(3, request.getParameter("time_learn"));
                        pstmt.setString(4, request.getParameter("if_multiple"));
                        pstmt.setString(5, request.getParameter("grade"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }

            %>
            
            

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM learnlist WHERE course_id = ? AND stu_SSN = ?");
                        
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("stu_SSN")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM learnlist");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>stu_SSN</th>
                        <th>course_id</th>
                        <th>time_learn</th>
                        <th>if_multiple</th>
                        <th>grade</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="learnlist.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="stu_SSN" size="15"></th>
                            <th><input value="" name="course_id" size="10"></th>
							<th><input value="" name="time_learn" size="10"></th>
                            <th><input type="radio"  value="YES"  name="if_multiple" size="15">YES
                                <input type="radio"  value="NO"  name="if_multiple" size="15">NO</th>
                            <th><input value="" name="grade" size="10"></th>  
                            
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="learnlist.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            
    
                            <%-- Get the SSN --%>
                            <td>
                                <input value="<%= rs.getInt("stu_SSN") %>" 
                                    name="stu_SSN" size="10">
                            </td>
    
                          

                            <%-- Get the section_id --%>
                            <td>
                                <input value="<%= rs.getInt("course_id") %>" 
                                    name="course_id" size="15">
                            </td>

                            <td>
                                <input value="<%= rs.getString("time_learn") %>" 
                                    name="time_learn" size="15">
                            </td>
                            
                            <td>
                                <input value="<%= rs.getString("if_multiple") %>" 
                                    name="if_multiple" size="15">
                            </td>
                            
                            <td>
                                <input value="<%= rs.getString("grade") %>" 
                                    name="grade" size="15">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
    
                            
                        </form>
                        <form action="learnlist.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("stu_SSN") %>" name="stu_SSN">
                            <input type="hidden" 
                                value="<%= rs.getInt("course_id") %>" name="course_id">
                            <input type="hidden" 
                                value="<%= rs.getString("time_learn") %>" name="time_learn">
                             <input type="hidden" 
                                value="<%= rs.getString("if_multiple") %>" name="if_multiple">
                              <input type="hidden" 
                                value="<%= rs.getString("grade") %>" name="grade">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
