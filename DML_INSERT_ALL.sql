create PROCEDURE DML_INSERT_ALL
    (v_nazwa_tabeli varchar2)
    AS
    v_insert_all VARCHAR(32767) := 'INSERT ALL';
    TYPE AssocTab IS TABLE OF varchar(30) INDEX BY PLS_INTEGER;
    t_nazwy_kolumn AssocTab := AssocTab();
    t_typy_danych AssocTab := AssocTab();
    v_insert_into varchar(32767);
    v_values varchar(32767) := '( ';
    v_iterator INTEGER := 1;
    v_liczba_wierszy INTEGER;
    v_sql_query varchar(150);
    v_sql_result_all varchar(150);
    v_sql_result_rekord varchar(150);
    v_sql_result_val varchar(150);
        BEGIN
            DBMS_OUTPUT.PUT_LINE('-- ' || v_nazwa_tabeli);
            v_insert_into :=  'INTO ' || v_nazwa_tabeli || ' (';


            SELECT COLUMN_NAME, Data_TYPE BULK COLLECT INTO t_nazwy_kolumn, t_typy_danych
            FROM USER_TAB_COLUMNS
            WHERE TABLE_NAME = v_nazwa_tabeli;


            FOR i IN 1 .. t_nazwy_kolumn.COUNT LOOP

            IF i = 1 THEN v_insert_into := v_insert_into || t_nazwy_kolumn(i);
            ELSE v_insert_into := v_insert_into || ', ' || t_nazwy_kolumn(i); END IF;

            end loop;

            v_insert_into := v_insert_into || ') VALUES ';

            DBMS_OUTPUT.PUT_LINE(v_insert_all);

            v_sql_query := 'SELECT COUNT(*) FROM ' || v_nazwa_tabeli;
            EXECUTE IMMEDIATE v_sql_query INTO v_sql_result_all;

            v_liczba_wierszy := 0;

            WHILE v_liczba_wierszy < TO_NUMBER(v_sql_result_all)  LOOP


                v_sql_query := 'SELECT COUNT(' || t_nazwy_kolumn(1) || ') FROM ' || v_nazwa_tabeli || ' WHERE ' || t_nazwy_kolumn(1) || ' = ' || v_iterator;
                EXECUTE IMMEDIATE v_sql_query INTO v_sql_result_rekord;
                IF TO_NUMBER(v_sql_result_rekord) > 0
                    THEN

                    v_liczba_wierszy := v_liczba_wierszy + 1;

                    FOR i IN t_nazwy_kolumn.FIRST .. t_nazwy_kolumn.LAST LOOP

                    v_sql_query := 'SELECT ' || t_nazwy_kolumn(i) || ' FROM ' || v_nazwa_tabeli || ' WHERE ' || t_nazwy_kolumn(1) || ' = ' || v_iterator;
                    EXECUTE IMMEDIATE v_sql_query INTO v_sql_result_val;
                    CASE t_typy_danych(i)
                    WHEN 'VARCHAR2' THEN  v_sql_result_val := '''' || v_sql_result_val || '''';
                    WHEN 'DATE' THEN  v_sql_result_val := 'TO_DATE(' || v_sql_result_val || ', dd-MM-YYYY)';
                    WHEN ' ' THEN  v_sql_result_val := 'NULL';
                    ELSE v_sql_result_val := v_sql_result_val;
                    END CASE;


                    CASE i
                        WHEN t_nazwy_kolumn.FIRST THEN v_values := v_values || v_sql_result_val;
                        ELSE v_values := v_values|| ', ' || v_sql_result_val;
                        END CASE;
                    end loop;

                v_values := v_values || ')';
                DBMS_OUTPUT.PUT_LINE(v_insert_into);
                DBMS_OUTPUT.PUT_LINE(v_values);
                v_values := ' (';
                end if;
                v_iterator := v_iterator + 1;

                end loop;

            DBMS_OUTPUT.PUT_LINE('SELECT * FROM DUAL; ');
        end;
/

