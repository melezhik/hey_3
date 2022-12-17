#!/usr/bin/env sh

source ./test_suite_management.sh

if [ ! -e hey ]; then
	cd ../
	if [ ! -e bin/hey ]; then
		echo "Run me from within the bash_unit_tests directory"
		exit 1
	fi
fi


HEY_INVOCATION="raku -I lib bin/hey"

test_01_usage () {
  #assert_equals expected actual message
  hey_usage=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION -v 2>&1 | head -n1)
  assert_equals "Usage:" \
	  "$hey_usage" \
	  "should provide usage without args"

  assert_status_code 2 "$HEY_INVOCATION -v > /dev/null 2>&1"
}

test_02_confirm_no_db(){
	assert "test ! -e $DB_LOCATION"
}

test_03_log_empty(){
	no_content_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION log 1 day)
	assert_equals "No timers found" "$no_content_output"
}
test_04_log-interrupts_empty(){
	no_content_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION log-interrupts 1 day)
	assert_equals "No interruptions found" "$no_content_output"
}

## Interruptions
test_05_add-interrupt(){
	new_interrupt_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION bob)
	assert_equals "Gotcha. 'twas bob" "$new_interrupt_output"
}
test_06_add-interrupt_w_proj_and_tag(){
	new_interrupt_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION bob @foo +bar)
	assert_equals "Gotcha. 'twas bob" "$new_interrupt_output"
	tag_count=$(sqlite3 $DB_LOCATION "select count(*) from tags where name='bar'")
	assert_equals "1" $tag_count;
	project_count=$(sqlite3 $DB_LOCATION "select count(*) from projects where name='foo'")
	assert_equals "1" $project_count;
}





# test_05_add_new() {
# 	file_path=$TEST_DATA_DIR"/raku_test_no_demo.toml"
# 	add_new_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION add $file_path | sed -e "s/ \/.*//")
# 	assert_equals "Successfully ingested" "$add_new_output"
# }
#
# test_06_confirm_db(){
# 	assert "test -e $DB_LOCATION"
# }
#
# test_07_confirm_data() {
# 	commands_count=$(sqlite3 $DB_LOCATION 'select count(*) from commands');
# 	tags_count=$(sqlite3 $DB_LOCATION 'select count(*) from tags');
# 	commands_tags_count=$(sqlite3 $DB_LOCATION 'select count(*) from commands_tags');
# 	assert_equals "1" "$commands_count"
# 	assert_equals "2" "$tags_count"
# 	assert_equals "2" "$commands_tags_count"
#
# }
#
# test_08_add_existing() {
# 	file_path=$TEST_DATA_DIR"/raku_test_no_demo.toml"
# 	add_existing_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION add $file_path | sed -e "s/ \/.*//")
# 	assert_equals "Successfully ingested" "$add_existing_output"
# }
#
# test_09_update() {
# 	file_path=$TEST_DATA_DIR"/raku_test_no_demo.toml"
# 	update_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION update $file_path | sed -e "s/ \/.*//")
# 	assert_equals "Successfully ingested" "$update_output"
# }
#
# test_10_demo_missing_asciicast(){
# 	asciicast_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION demo raku_test_no_demo 2>&1 \
# 		| head -n1			)
# 	assert_equals "No asciicast url was specified for raku_test_no_demo" "$asciicast_output"
# }
#
# test_11_empty_demos_listing(){
# 	demos_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION demos )
# 	assert_equals "You don't have any commands with asciicast demos." "$demos_output"
# }
# test_12_add_asciicast() {
# 	file_path=$TEST_DATA_DIR"/raku_test_no_demo.cast"
# 	add_cast_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION update $file_path | sed -e "s/ \/.*//")
# 	assert_equals "Successfully ingested" "$add_cast_output"
# }
#
# test_13_demo_asciicast(){
# 	asciicast_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION demo raku_test_no_demo \
# 		| grep "echo" \
# 		| sed -e 's/^.* "//' -e 's/".*$//'			)
# 	assert_equals "test data" "$asciicast_output"
# }
# test_14_populated_demos_listing(){
# 	demos_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION demos | grep "raku_test_no_demo" )
# 	assert_equals "│ raku_test_no_demo │ raku_test_no_demo test description rtnddescription │" "$demos_output"
# }
#
# #  searching
# # let's add a second one
# test_15_add_second_command(){
# 	file_path=$TEST_DATA_DIR"/something_else.toml"
# 	add_new_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION add $file_path | sed -e "s/ \/.*//")
# 	assert_equals "Successfully ingested" "$add_new_output"
# }
#
# test_16_list_shows_all(){
# 	list_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION list | wc -l | sed -e 's/^ *//')
# 	assert_equals "6" "$list_output"
# }
#
# test_17_filtered_list_is_filtered(){
# 	list_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION list demos | wc -l | sed -e 's/^ *//')
# 	assert_equals "5" "$list_output"
# }
#
# test_18_find_one_in_desc() {
# 	find_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION find rtnddescription | wc -l | sed -e 's/^ *//')
# 	assert_equals "5" "$find_output"
# }
# test_19_find_two_in_desc_with_same_term() {
# 	find_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION find description | wc -l | sed -e 's/^ *//')
# 	assert_equals "6" "$find_output"
# }
# test_20_find_two_in_desc_with_2_terms() {
# 	find_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION find rtnddescription sedescription  | wc -l | sed -e 's/^ *//')
# 	assert_equals "6" "$find_output"
# }
#
# test_21_find_two_in_desc_with_2_terms_1_result() {
# 	find_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION find rtnddescription booooogus  | wc -l | sed -e 's/^ *//')
# 	assert_equals "5" "$find_output"
#
# }
#
# test_22_stemming() {
# 	# the word in the data is "description" NOT "descriptions"
# 	find_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION find descriptions  | wc -l | sed -e 's/^ *//')
# 	assert_equals "6" "$find_output"
# }
#
# test_26_tag_search() {
# 	find_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION find se2  | wc -l | sed -e 's/^ *//')
# 	assert_equals "5" "$find_output"
# }
#
# test_27_tag_search_2_rows() {
# 	find_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION find se2  | wc -l | sed -e 's/^ *//')
# 	assert_equals "5" "$find_output"
# }
#
# # just confirming that it works and has the amount of output we're expecting
# test_28_show() {
# 	show_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION show raku_test_no_demo  | wc -l | sed -e 's/^ *//')
# 	assert_equals "20" "$show_output"
# }
#
# test_29_template() {
#
# 	template_destination="bash_unit_tests/test_data/test_executable.toml"
# 	PATH="bash_unit_tests/test_data:$PATH";
# 	creation_output=$(XDG_CONFIG_HOME=$XDG_CONFIG_HOME $HEY_INVOCATION template test_executable | sed -e "s/ to .*//")
# 	assert_equals "Copying fresh template" "$creation_output"
# 	assert "test -e $template_destination"
# 	rm $template_destination
#
# }
#
# test_30_add-many() {
# 	ingestion_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION add-many $TEST_DATA_DIR | tail -n1);
# 	assert_equals "3 files were successfuly ingested out of 3 total files with .toml or .cast extensions." "$ingestion_output";
# }
#
# test_31_list-json(){
# 	# WARNING: ORDER OF JSON ELEMENTS IS NOT GUARANTEED
# 	command -v jq > /dev/null
# 	if [ $? -eq 0 ]; then
# 		list_json_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION list-json | jq '.commands | length');
# 		assert_equals '2' "$list_json_output"
# 	else
# 		echo "SKIPPING list-json TEST. jq isn't installed"
# 		assert true
# 	fi
# }
#
# test_32_show-json(){
# 	# WARNING: ORDER OF JSON ELEMENTS IS NOT GUARANTEED
# 	command -v jq > /dev/null
# 	if [ $? -eq 0 ]; then
# 		show_json_output=$(XDG_DATA_HOME=$XDG_DATA_HOME $HEY_INVOCATION show-json raku_test_no_demo | jq '.command.name' );
# 		assert_equals '"raku_test_no_demo"' "$show_json_output"
# 	else
# 		echo "SKIPPING show-json TEST. jq isn't installed"
# 		assert true
# 	fi
# }
