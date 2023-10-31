// Copyright(C) 2021-2022 Lars Pontoppidan. All rights reserved.
import vmon
import os
import readline

fn watch_callback(watch_id vmon.WatchID, action vmon.Action, root_path string, file_path string, old_file_path string, user_data voidptr) {
	// Don't cast and use if user_data is null
	// This is only needed since we use the same
	// watch_callback for multiple watchers
	if !isnil(user_data) {
		mut ts := unsafe { &TestStruct(user_data) }
		ts.i++
		println('${ts}'.replace('\n', ' ').replace('    ', '')) // flatten output
	}

	base_msg := 'Watcher id ${watch_id} in "${root_path}" got ${action} event'
	match action {
		.create {
			println('${base_msg} "${file_path}"')
		}
		.delete {
			println('${base_msg} "${file_path}"')
		}
		.modify {
			println('${base_msg} "${file_path}"')
		}
		.move {
			println('${base_msg} "${old_file_path}" to "${file_path}"')
		}
	}
}

struct TestStruct {
mut:
	i int
}

fn main() {
	mut ts := &TestStruct{}

	flags := u32(vmon.WatchFlag.recursive) | u32(vmon.WatchFlag.follow_symlinks)

	path := os.join_path(os.temp_dir(), 'watch_me')
	os.mkdir_all(path) or {}
	watch_id := vmon.watch(path, watch_callback, flags, ts) or { panic(err) }

	mut r := readline.Readline{}
	r.read_line('Press "Enter" key to stop watching "${path}"\n') or {}

	vmon.unwatch(watch_id)
	unsafe {
		free(ts)
	}
	println('Bye bye, thanks for watching')
}
