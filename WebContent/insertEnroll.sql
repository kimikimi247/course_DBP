CREATE OR REPLACE PROCEDURE InsertEnroll(studentID IN NUMBER, courseID IN VARCHAR2,
					courseIDNO IN NUMBER, result OUT VARCHAR2 )
IS
	credit_limit_over EXCEPTION;
	duplicate_course EXCEPTION;
	too_many_students EXCEPTION;
	duplicate_period EXCEPTION;
	courseSUM NUMBER;
	courseCREDIT NUMBER;
	courseCOUNT NUMBER;
	periodCOUNT1 NUMBER;
	periodCOUNT2 NUMBER;
	courseMAX NUMBER;
	courseCURRENT NUMBER;

BEGIN
	result := ' ';
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

	IF (courseSUM + courseCREDIT) >18 THEN
		RAISE credit_limit_over;
	END IF;

	/*�ߺ��� ����*/
	SELECT COUNT(*)
	INTO courseCOUNT
	FROM enroll
	WHERE s_id = studentID AND c_id = courseID;

	IF courseCOUNT > 0 THEN
		RAISE duplicate_course;
	END if;

	/*������û �ο� �ʰ�*/
	SELECT c_max, c_current
	INTO courseMAX, courseCURRENT
	FROM course
	WHERE c_id = courseID;

	IF (courseCURRENT+1) > courseMAX THEN
		RAISE too_many_students;
	END IF;
	
	/*�ߺ��� �ð�*/
	SELECT COUNT(*)
	INTO periodCOUNT1
	FROM course
	WHERE c_period IN (SELECT c.c_period FROM enroll e, course c WHERE e.s_id = studentID AND e.c_id IN (SELECT c_id FROM course new_c  INNER JOIN course enrolled_c ON new_c.c_day1 = enrolled_c.c_day1));

	SELECT COUNT(*)
	INTO periodCOUNT2
	FROM course
	WHERE c_period IN (SELECT c.c_period FROM enroll e, course c WHERE e.s_id = studentID AND e.c_id IN (SELECT c_id FROM course new_c  INNER JOIN course enrolled_c ON new_c.c_day2 = enrolled_c.c_day2));

	IF periodCOUNT1 > 0 OR periodCOUNT2 > 0 THEN
		RAISE duplicate_period;
	END IF;

	INSERT INTO enroll(s_id, c_id, c_number)
	VALUES (studentID, courseID, courseIDNO);
	
	UPDATE course
	SET c_current = courseCURRENT + 1
	WHERE c_id = courseID;

	UPDATE student
	SET s_credit = (courseSUM + courseCREDIT)
	WHERE s_id = studentID;

	result := '������û�� �Ϸ�Ǿ����ϴ�.';
	DBMS_OUTPUT.put_line(result);

	COMMIT;

EXCEPTION
	WHEN credit_limit_over THEN
		result := '�ִ������� �ʰ��Ͽ����ϴ�.';
		DBMS_OUTPUT.put_line(result);
	WHEN duplicate_course THEN
		result :='�̹� ������û�� �����Դϴ�.';
		DBMS_OUTPUT.put_line(result);
	WHEN too_many_students THEN
		result :='�ִ� ������û �ο��� �ʰ��Ͽ� ����� �� �����ϴ�.';
		DBMS_OUTPUT.put_line(result);
	WHEN duplicate_period THEN
		result :='���� �ð��� ������û�� ������ �ֽ��ϴ�.';
		DBMS_OUTPUT.put_line(result);
	WHEN OTHERS THEN
		ROLLBACK;
	result := SQLCODE;
END;
/