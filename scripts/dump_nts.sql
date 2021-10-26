/**
 * Dumps the result of the given select-sparql query into a file
 * or a sequence of files based on a file size limit.
 *
 * @param query A select query. Only the first three variables in the projection will be dumped
 * @param out_file A base filename. '.nt' will be autmatically appended.
 * @param file_length_limit A result set is split to multiple files according to this limit.
 *        If it is greater 0 a sequence number will be appended to the filename.
 */
create procedure dump_query_nt(in query varchar, in out_file varchar, in file_length_limit integer := -1)
{
    declare file_name varchar;
    declare env, ses any;
    declare ses_len, max_ses_len, file_len, file_idx integer;
    declare state, msg, descs any;
    declare chandle any;
    declare sub any;
    declare sql any;
    set isolation = 'uncommitted';
    max_ses_len := 10000000;
    file_len := 0;
    file_idx := 1;

    if(file_length_limit >= 0) {
        file_name := sprintf ('%s-%06d.nt', out_file, file_idx);
    } else {
        file_name := sprintf ('%s.nt', out_file);
    }

    string_to_file (file_name || '.query', query, -2);
    env := vector (0, 0, 0);
    ses := string_output ();


    state := '00000';
    sql := sprintf('sparql define input:storage "" %s', query);

    exec(sql, state, msg, vector (), 0, descs, null, chandle);
    if (state <> '00000') {
        signal (state, msg);
    }

    while(exec_next(chandle, state, msg, sub) = 0) {
        if (state <> '00000') {
            signal (state, msg);
        }

        http_nt_triple (env, sub[0], sub[1], sub[2], ses);
        ses_len := length (ses);

        if (ses_len > max_ses_len) {
            file_len := file_len + ses_len;
            if (file_length_limit >= 0 and file_len > file_length_limit) {
                string_to_file (file_name, ses, -1);
                file_len := 0;
                file_idx := file_idx + 1;
                file_name := sprintf ('%s-%06d.nt', out_file, file_idx);
                env := vector (0, 0, 0);
            }
            else {
              string_to_file (file_name, ses, -1);
            }

            ses := string_output ();
        }
    }
    if (length (ses)) {
        string_to_file (file_name, ses, -1);
    }

    exec_close(chandle);
};

