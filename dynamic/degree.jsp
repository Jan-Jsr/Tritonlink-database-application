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
                            "INSERT INTO degree VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("ld_units")));
                        pstmt.setString(3, request.getParameter("ld_grade"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("ud_units")));
                        pstmt.setString(5, request.getParameter("ud_grade"));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("total_units")));
                        pstmt.setString(7, request.getParameter("total_grade"));
                        pstmt.setString(8, request.getParameter("name"));
                        pstmt.setString(9, request.getParameter("if_ms"));
                        pstmt.setInt(10, Integer.parseInt(request.getParameter("elective_units")));
                        
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE degree SET ld_units = ?, ld_grade = ?, ud_units = ?, ud_grade = ?, total_units = ? , total_grade = ?, name = ?, if_ms = ?, elective_units = ? WHERE id = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ld_units")));
                        pstmt.setString(2, request.getParameter("ld_grade"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("ud_units")));
                        pstmt.setString(4, request.getParameter("ud_grade"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("total_units")));
                        pstmt.setString(6, request.getParameter("total_grade"));
                        pstmt.setString(7, request.getParameter("name"));
                        pstmt.setString(8, request.getParameter("if_ms"));
                        pstmt.setInt(9, Integer.parseInt(request.getParameter("elective_units")));
                        pstmt.setInt(10, Integer.parseInt(request.getParameter("id")));
                        

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
                            "DELETE FROM degree WHERE id = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("id")));
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
                        ("SELECT * FROM degree");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>id</th>
                        <th>ld_units</th>
                        <th>ld_grade</th>
                        <th>ud_units</th>
                        <th>ud_grade</th>
                        <th>total_units</th>
                        <th>total_grade</th>
                        <th>name</th>
                        <th>if_ms</th>
						<th>elective_units</th>
                        <th>Action</th>
                        
                    </tr>
                    <tr>
                        <form action="degree.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="id" size="10"></th>
                            <th><input value="" name="ld_units" size="10"></th>
                            <th><input value="" name="ld_grade" size="15"></th>
                            <th><input value="" name="ud_units" size="15"></th>
                            <th><input value="" name="ud_grade" size="15"></th>
                            <th><input value="" name="total_units" size="10"></th>
                            <th><input value="" name="total_grade" size="10"></th>
                            <th><input value="" name="name" size="15"></th>
                            <th><input type="radio" value="YES" name="if_ms" size="15">YES
                                <input type="radio" value="NO" name="if_ms" size="15">NO</th>
							<th><input value="" name="elective_units" size="10"></th>

                            <th><input type="submit" value="Insert"></th>

                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="degree.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            
    
                            <%-- Get the id --%>
                            <td>
                                <input value="<%= rs.getInt("id") %>" 
                                    name="id" size="10">
                            </td>
    
                            <%-- Get the number --%>
                            <td>
                                <input value="<%= rs.getInt("ld_units") %>"
                                    name="ld_units" size="15">
                            </td>

                            <td>
                                <input value="<%= rs.getString("ld_grade") %>"
                                    name="ld_grade" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("ud_units") %>"
                                    name="ud_units" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("ud_grade") %>"
                                    name="ud_grade" size="15">
                            </td>

                            <td>
                                <input value="<%= rs.getInt("total_units") %>"
                                    name="total_units" size="15">
                            </td>

                            <td>
                                <input value="<%= rs.getString("total_grade") %>"
                                    name="total_grade" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("name") %>"
                                    name="name" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("if_ms") %>"
                                    name="if_ms" size="15">
                            </td>
							 <td>
                                <input value="<%= rs.getInt("elective_units") %>"
                                    name="elective_units" size="10">
                            </td>

    
                            
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="degree.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("id") %>" name="id">
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