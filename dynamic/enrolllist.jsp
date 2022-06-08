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
                            "INSERT INTO enrolllist VALUES (?, ?, ?, ?)");

                        
			            pstmt.setInt(1, Integer.parseInt(request.getParameter("stu_SSN")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("sec_id")));
                        pstmt.setString(3, request.getParameter("if_mutiple"));
                        pstmt.setString(4, request.getParameter("if_flexible"));
                        
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
                            "DELETE FROM enrolllist WHERE stu_SSN = ? AND sec_id = ?");
                        
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("stu_SSN")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("sec_id")));
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
                        ("SELECT * FROM enrolllist");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>stu_SSN</th>
                        <th>sec_id</th>
                        <th>if_mutiple</th>
                        <th>if_flexible</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="enrolllist.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="stu_SSN" size="15"></th>
                            <th><input value="" name="sec_id" size="10"></th>
                            <th><input type="radio"  value="YES"  name="if_mutiple" size="15">YES
                                <input type="radio"  value="NO"  name="if_mutiple" size="15">NO
                               </th>
                            <th><input type="radio"  value="YES"  name="if_flexible" size="15">YES
                                <input type="radio"  value="NO"  name="if_flexible" size="15">NO
                               </th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="enrolllist.jsp" method="get">
                            

                            
    
                            <%-- Get the SSN --%>
                            <td>
                                <input value="<%= rs.getInt("stu_SSN") %>" 
                                    name="stu_SSN" size="10">
                            </td>
    
                          

                            <%-- Get the sec_id --%>
                            <td>
                                <input value="<%= rs.getInt("sec_id") %>" 
                                    name="sec_id" size="15">
                            </td>
                            
                            <td>
                                <input value="<%= rs.getString("if_mutiple") %>"
                                    name="if_mutiple" size="15">
                            </td>
                            
                            <td>
                                <input value="<%= rs.getString("if_flexible") %>"
                                    name="if_flexible" size="15">
                            </td>
    
                            
                        </form>
                        <form action="enrolllist.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("stu_SSN") %>" name="stu_SSN">
                            <input type="hidden" 
                                value="<%= rs.getInt("sec_id") %>" name="sec_id">
                            <input type="hidden" 
                                value="<%= rs.getString("if_mutiple") %>" name="if_mutiple">
                             <input type="hidden" 
                                value="<%= rs.getString("if_flexible") %>" name="if_flexible">
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
