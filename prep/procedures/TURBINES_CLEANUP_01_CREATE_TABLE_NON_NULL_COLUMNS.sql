CREATE OR REPLACE PROCEDURE EDG.PREP.TURBINES_CLEANUP_01_CREATE_TABLE_NON_NULL_COLUMNS("TABLE_NAME" VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
EXECUTE AS OWNER
AS '
    // This procedure creates a new table with only the non-null columns from the source table

    // Get column names and generate a single query to count non-nulls for all columns
    var get_columns_sql = `
            SELECT 
                LISTAGG(''COUNT("'' || column_name || ''") as "'' || column_name || ''_count"'', '', '') as count_sql,
                LISTAGG(''"'' || column_name || ''"'', '', '') as all_cols
            FROM information_schema.columns 
            WHERE table_name = ''${TABLE_NAME}'' AND table_schema = ''RAW''
        `;

    var stmt1 = snowflake.createStatement({ sqlText: get_columns_sql });
    var result1 = stmt1.execute();
    result1.next();

    var count_sql = result1.getColumnValue(1);
    var all_cols = result1.getColumnValue(2);

    // Single query to count non-nulls for all columns at once
    var check_all_sql = `SELECT ${count_sql} FROM RAW.${TABLE_NAME}`;
    var stmt2 = snowflake.createStatement({ sqlText: check_all_sql });
    var result2 = stmt2.execute();
    result2.next();


    // Build list of non-empty columns
    var cols_array = all_cols.split('', '');
    var non_null_columns = [];

    for (var i = 0; i < cols_array.length; i++) {
        if (result2.getColumnValue(i + 1) > 0) {
            non_null_columns.push(cols_array[i]);
        }
    }


    // Create view
    if (non_null_columns.length > 0) {
        var col_list = non_null_columns.join('', '');

        var create_view_sql = `
                CREATE OR REPLACE TABLE ${TABLE_NAME}_NON_NULL_COLS 
                AS SELECT ${col_list} FROM RAW.${TABLE_NAME}
            `;

        var stmt3 = snowflake.createStatement({ sqlText: create_view_sql });
        stmt3.execute();
        return `View created with ${non_null_columns.length} columns`;
    } else {
        return "No non-null columns found";
    }
';