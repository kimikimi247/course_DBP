CREATE OR REPLACE PROCEDURE InserEnroll(studentID IN VARCHAR2, courseID IN VARCHAR2,
					courseIDNO IN NUMBER, result OUT VARCHAR2 )
IS
	credit_limit_over EXCEPTION;
	duplicate_course EXCEPTION;
	too_many_students EXCEPTION;
	duplicate_time EXCEPTION;
	courseSUM NUMBER;
	courseCREDIT NUMBER;
	courseCOUNT NUMBER;
	courseMAX NUMBER;
	courseCURRENT NUMBER;

BEGIN
	result := "";
	DBMS_OUTPUT.put_line(studentID || '���� �����ȣ ' || courseID ||
	', �й� ' || courseIDNO || '�� ���� ����� ��û�Ͽ����ϴ�.');

	/*�ִ����� �ʰ�*/
	SELECT SUM(c.c_credit)
	INTO courseSUM
	FROM course c, enroll e
	WHERE e.s_id = studentID AND e.c_id = c.c_id AND e.c_number = c.c_number;

	SELECT c_credit
	INTO courseCREDIT
	FROM course
	WHERE c_id = courseID AND c_number = courseIDNO;

	IF( courseSUM + courseCREDIT >18) THEN
		RAISE credit_limit_over EXCEPTION;
	END IF;

	/*�ߺ��� ����*/
	SELECT COUNT(*)
	INTO courseCOUNT
	FROM enroll
	WHERE s_id = studentID AND c_id = courseID;

	IF (courseCOUNT > 0) THEN
		RAISE duplicate_course;
	END if;

	/*������û �ο� �ʰ�*/
	SELECT c_max, c_current
	INTO courseMAX, courseCURRENT
	FROM course
	WHERE c_id = courseID;

	IF ( (courseCURRENT+1) > course MAX) THEN
		RAISE too_many_students;
	END IF;
	
	/*�ߺ��� �ð�*/
	SELECT COUNT(*)
	INTO courseCOUNT
	FROM course c
	WHERE c.c_id = courseID AND c.c_period IN  (SELECT c_period
						FROM 