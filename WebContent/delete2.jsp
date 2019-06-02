<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<html><head><title>수강신청 입력</title></head>
<body>
<%@ include file="top.jsp" %>
<%   if (session_id==null) response.sendRedirect("login.jsp");  %>

<table width="75%" align="center" border>
<br>
<tr>
         <th>과목번호</th>
         <th>분반</th>
         <th>과목명</th>
         <th>교수</th>
         <th>시간</th>
         <th>학점</th>
         <th>수강신청</th>
      </tr>
<%
	Connection myConn = null;     
Statement stmt = null;
	PreparedStatement pstmt = null;
	ResultSet myResultSet = null;   String mySQL = "";
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user="sook";     String passwd="2019";
     String dbdriver = "oracle.jdbc.driver.OracleDriver";    
     session_id=(String)session.getAttribute("user");
 	
     String sql = "select * from COURSE c, enroll e WHERE c.c_id = e.c_id AND c.c_number = e.c_number AND e.s_id ='" + session_id + "'";
     //session_id = session.getId();
	System.out.println("sessionid:"+session_id);
     
     String id = request.getParameter("userID");
     String pwd = request.getParameter("userPassword");
	int cmax = 30;
	try {
		
	///	int result = stmt.executeQuery(sql);
		
		Class.forName(dbdriver);
	    myConn =  DriverManager.getConnection (dburl, user, passwd);
		stmt = myConn.createStatement();	
		pstmt = myConn.prepareStatement(sql);
		pstmt.setString(1,"C1234");
//		pstmt.setString(2,pwd);
		
		
    } catch(SQLException ex) {
	     System.err.println("SQLException: " + ex.getMessage());
    }

//mySQL = "select c_id,c_id_no,c_name,c_unit from course where c_id not in (select c_id from enroll where s_id='" + session_id + "')";
	mySQL="select * from course";
	myResultSet = pstmt.executeQuery();
	System.out.println("myreslutset"+myResultSet);

	if (myResultSet != null) {
	while (myResultSet.next()) {
		
		
		String c_id = myResultSet.getString("c_id");//과목번호
		String c_name = myResultSet.getString("c_name");//과목명
	//	System.out.println("c_id:"+c_id);
	//	System.out.println("c_name"+c_name);

		
		int c_credit= myResultSet.getInt("c_credit");//학점			
		int c_number = myResultSet.getInt("c_number");//분반
		int p_id = myResultSet.getInt("p_id");
		int c_day1 = myResultSet.getInt("c_day1");
		int c_day2 = myResultSet.getInt("c_day2");
		int c_period = myResultSet.getInt("c_period");
		
String c_time = "";
		
		switch(c_day1){
		case 1:
			c_time = "월";
			break;
		case 2:
			c_time = "화";
			break;
		case 3:
			c_time = "수";
			break;
		case 4:
			c_time = "목";
			break;
		case 5:
			c_time = "금";
			break;
		default:
			break;
		}
		
		c_time = c_time + " " + c_period + " 교시";
		
		switch(c_day2){
		case 1:
			c_time = "\n" + c_time +"월";
			break;
		case 2:
			c_time = "\n" + c_time +"화";
			break;
		case 3:
			c_time = "\n" + c_time +"수";
			break;
		case 4:
			c_time = "\n" + c_time +"목";
			break;
		case 5:
			c_time = "\n" + c_time +"금";
			break;
		default:
			break;
		}
		
		c_time = c_time + " " + c_period + " 교시";
		
		String pSQL = "select p_name from professor where p_id = '" + p_id + "'";
		Statement prof_stmt = myConn.createStatement();
		ResultSet rs = prof_stmt.executeQuery(pSQL);
		rs.next();
		String p_name = rs.getString("p_name");
%>
<tr>
  <td align="center"><%= c_id %></td>
  <td align="center"><%= c_number %></td> 
  <td align="center"><%= c_name %></td>
  <td align="center"><%= p_name %></td>
  <td align="center"><%= c_time %></td>
  <td align="center"><%= c_credit %></td>
  <td align="center"><a href="delete_verify.jsp?c_id=<%= c_id %>&c_id_no=<%= c_number %>">삭제</a></td>
</tr>
<%
		}
	}
	//stmt.close(); 
	//pstmt.close();
	//myConn.close();
%>
</table></body></html>