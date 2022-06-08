
<html>

<body>
<%@page import="java.util.*, java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%

Connection conn = null;
Statement statement = null;
PreparedStatement ps = null;
ResultSet rs = null;
PreparedStatement pstmt1 = null;
PreparedStatement pstmt2 = null;
ResultSet rs1 = null;
ResultSet rs2 = null;
try{
    // Registering Postgresql JDBC driver with the DriverManager
    Class.forName("org.postgresql.Driver");
    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/cse132b?user=postgres&password=Tswhy/569");
	String action = request.getParameter("action");
	statement = conn.createStatement();
	rs = statement.executeQuery("SELECT sec.id, c.course_id FROM section sec, class c " +
			"WHERE sec.class=c.id AND c.quarter='2018-SPRING' ORDER BY sec.id"); 
	%>
	<form action="reviewSchedule.jsp" method="post">
	<input type="hidden" value="pick" name="action">
	<select id="id" required ="required" name="id">
	<% 
	while(rs.next()){
	%>
	    <option value="<%=rs.getInt("id")%>"><%=rs.getInt("course_id")%> Section <%=rs.getInt("id")%></option>
	<% 
	}
	%>
	</select>
	<input type="submit" value="Submit">
	</form>
	<%
	if (request.getParameter("action")!= null && request.getParameter("action").equals("pick")){
		%> 	
		<table cellspacing="5">
			<table border="1" cellspacing="5">
			<thead>
			<tr>
			<th>SID</th>
			<th>Course</th>
			<th>Start Date</th>
			<th>End Date</th>
			</tr>
			</thead>
		<%
		ps = conn.prepareStatement("SELECT sec.id, c.course_id FROM section sec, class c " +
				"WHERE sec.class=c.id AND c.quarter='2018-SPRING' AND sec.id=?");
		
		ps.setInt(1, Integer.parseInt(request.getParameter("id")));
		rs = ps.executeQuery();
		while(rs.next()){
		%>
		<tr>
		<form action="reviewSchedule.jsp" method="post">
		    <input type="hidden" value="report" name="action">
		    <input type="hidden" name="id" value="<%=request.getParameter("id") %>">
			<td><%=rs.getInt("id")%></td>
			<td><%=rs.getInt("course_id")%></td>
			<td><input name="start" value="" placeholder="S/M/T/W/Th/F/Sa">
			<td><input name="end" value="" placeholder="S/M/T/W/Th/F/Sa">
		    <td><input type="submit" value="Select Section"></td>
		</form>
		</tr>
		</table>
		</table>
	 <%	}
	}
	if (request.getParameter("action")!= null && request.getParameter("action").equals("report")){
		System.out.println(request.getParameter("action"));
		if( request.getParameter("start")!= null && request.getParameter("end")!= null ){
	
			String sql1 = "WITH enrolled AS (" +
					  "SELECT s.SSN FROM student s, learning e, section sec, class c " +
					  "WHERE s.ssn=e.student_ssn AND e.section_id=sec.id AND sec.class=c.id AND c.quarter='2018-SPRING' AND sec.id=?) " +
					  "SELECT m.weekday, m.begintime, m.endtime FROM student s, learning e, section sec, session m, class c, enrolled " +
					  "WHERE s.ssn=e.student_ssn AND e.section_id=sec.id AND m.section_id=sec.id AND sec.class=c.id AND c.quarter='2018-SPRING' AND s.SSN=enrolled.SSN;";
			pstmt1 = conn.prepareStatement(sql1, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			/*
			pstmt1 = conn.prepareStatement("WITH enrolled AS (" +
					  "SELECT s.SSN FROM student s, learning e, section sec, class c " +
					  "WHERE s.ssn=e.student_ssn AND e.section_id=sec.id AND sec.class=c.id AND c.quarter='2018-SPRING' AND sec.id=?) " +
					  "SELECT m.weekday, m.begintime, m.endtime FROM student s, learning e, section sec, session m, class c, enrolled " +
					  "WHERE s.ssn=e.student_ssn AND e.section_id=sec.id AND m.section_id=sec.id AND sec.class=c.id AND c.quarter='2018-SPRING' AND s.SSN=enrolled.SSN;");
			*/
			pstmt1.setInt(1, Integer.parseInt(request.getParameter("id")));
			rs1 = pstmt1.executeQuery();
			String sql2 = "WITH enrolled AS (" +
					  "SELECT s.SSN FROM student s, learning e, section sec, class c " +
					  "WHERE s.ssn=e.student_ssn AND e.section_id=sec.id AND sec.class=c.id AND c.quarter='2018-SPRING' AND sec.id=?) " +
					  "SELECT r.date, r.begintime, r.endtime FROM student s, learning e, section sec, review_session r, class c, enrolled " +
					  "WHERE s.ssn=e.student_ssn AND e.section_id=sec.id AND r.section_id=sec.id AND sec.class=c.id AND c.quarter='2018-SPRING' AND s.SSN=enrolled.SSN;";
			pstmt2 = conn.prepareStatement(sql2, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			/*
			pstmt2 = conn.prepareStatement("WITH enrolled AS (" +
							  "SELECT s.SSN FROM student s, learning e, section sec, class c " +
							  "WHERE s.ssn=e.student_ssn AND e.section_id=sec.id AND sec.class=c.id AND c.quarter='2018-SPRING' AND sec.id=?) " +
							  "SELECT r.date, r.begintime, r.endtime FROM student s, learning e, section sec, review_session r, class c, enrolled " +
							  "WHERE s.ssn=e.student_ssn AND e.section_id=sec.id AND r.section_id=sec.id AND sec.class=c.id AND c.quarter='2018-SPRING' AND s.SSN=enrolled.SSN;");
			*/
			pstmt2.setInt(1, Integer.parseInt(request.getParameter("id")));
			rs2 = pstmt2.executeQuery();
			
			
			String currDay = request.getParameter("start");
			int i,j;
			String begint;
			String endt;
			String curr;
			boolean show = true;
			%>
			<h3>Available Times(1hr)</h3>
			<table>
			<tr>
			<td>
			<table border="1" style="color:blue">
			<tr>
			<td>Day
			(Symbol)</td>
			<td>BeginTime
			(00:00)</td>
			<td>EndTime
			(00:00)</td>
			</tr>
			<%
			while(true){
				for(i=8;i<20;i++){
					if(i<10){
						begint = "0" + i + "00";
						if(i==9)
							endt = "1000";
						else
							endt = "0900";
					}
					else{
						begint = i + "00";
						endt = (i+1) + "00";
					}
					System.out.println("TIME IS: " + begint + endt);
					while(rs1.next()){
						String curr1 = rs1.getString("weekday");
						String curr2 = rs1.getString("begintime");
						String curr3 = rs1.getString("endtime");
						System.out.println(curr1+curr2+curr3);
						System.out.println(curr1==currDay);
						System.out.println(curr1);
						System.out.println(currDay);
							if(curr1.equals(currDay)
									&& ((Integer.parseInt(curr2)>=Integer.parseInt(begint)&&Integer.parseInt(curr2)<Integer.parseInt(endt))
											||(Integer.parseInt(curr3)>Integer.parseInt(begint)&&Integer.parseInt(curr3)<Integer.parseInt(endt))||
											(Integer.parseInt(curr2)<=Integer.parseInt(begint)&&Integer.parseInt(curr3)>=Integer.parseInt(endt)))){ //curr[j] has day
								//curr[curr.length-1] has time
								//A conflict, same time and day is found	
								System.out.println("CONFLICT at:" + curr1 + "-" + curr2 + "-" + curr3);
								show=false;
								
							}
					}
					while(rs2.next()){
						String curr1 = rs2.getString("date");
						String curr2 = rs2.getString("begintime");
						String curr3 = rs2.getString("endtime");
							if(curr1.equals(currDay)
									&& ((Integer.parseInt(curr2)>=Integer.parseInt(begint)&&Integer.parseInt(curr2)<Integer.parseInt(endt))
											||(Integer.parseInt(curr3)>Integer.parseInt(begint)&&Integer.parseInt(curr3)<Integer.parseInt(endt))||
											(Integer.parseInt(curr2)<=Integer.parseInt(begint)&&Integer.parseInt(curr3)>=Integer.parseInt(endt)))){ //curr[j] has day
								//curr[curr.length-1] has time
								//A conflict, same time and day is found	
								System.out.println("CONFLICT at:" + curr1 + "-" + curr2 + "-" + curr3);
								show=false;
								
							}
					}
					if(show){
					%>
					<tr>
					<td><%=currDay%></td>
					<td><%=begint%></td>
					<td><%=endt%></td>
					</tr>
					<%
					}
					show=true;
					rs1.beforeFirst();
					rs2.beforeFirst();
				}
				if(currDay.equals(request.getParameter("end"))){
					break;
				}
				//Set next day
				if(currDay.equals("S")){
					currDay="M";
				}
				else if(currDay.equals("M")){
					currDay="T";
				}
				else if(currDay.equals("T")){
					currDay="W";
				}
				else if(currDay.equals("W")){
					currDay="Th";
				}
				else if(currDay.equals("Th")){
					currDay="F";
				}
				else if(currDay.equals("F")){
					currDay="Sa";
				}
				else if(currDay.equals("Sa")){
					currDay="S";
				}
				else
					break;
			}
			%>
			</table>
			</td>
			<td>Legend:
			<table border="1">
			<tr><td>Day:</td><td>Symbol:</td></tr>
			<tr><td>Sunday</td><td>S</td></tr>
			<tr><td>Monday</td><td>M</td></tr>
			<tr><td>Tuesday</td><td>T</td></tr>
			<tr><td>Wednesday</td><td>W</td></tr>
			<tr><td>Thursday</td><td>Th</td></tr>
			<tr><td>Friday</td><td>F</td></tr>
			<tr><td>Saturday</td><td>Sa</td></tr>
			</table></td></table>
			<%	
		}
	}

} 
catch (SQLException e){
	System.out.println(e.getSQLState());
}
finally{
}%>
</body>
</html>