# vmon

A V wrapper for [septag/dmon](https://github.com/septag/dmon) - an asynchronous directory file change watcher for Windows, macOS and Linux.

Currently `vmon` offers a few additional features over the code in `dmon`.

* Automatic shared access to the user data in the callback thread (via `sync.Mutex`)
* Automatic init/free of memory resources on clean program exits

# Install

```bash
git clone https://github.com/Larpon/vmon ~/.vmodules/vmon
v run ~/.vmodules/vmon/examples/watch_and_unwatch
```

# Usage

To watch a directory asynchronous for *file* changes simply do:
```v
import os
import vmon

fn watch_callback(watch_id vmon.WatchID, action vmon.Action, root_path string, file_path string, old_file_path string, user_data voidptr) {
	// ... do stuff here
}

fn main() {
	vmon.watch(os.home_dir(), watch_callback, 0, voidptr(0)) or { panic(err) }
	// ... do stuff here
	time.sleep(10 * time.second)
}
```

# Notes

Please note that [septag/dmon](https://github.com/septag/dmon) is [licensed](https://github.com/septag/dmon#license-bsd-2-clause) under BSD 2-clause - while the V wrapper code is licensed under MIT.

Please also note that your user need correct file permission access
to the directories you're trying to watch. So watching a place
like `/tmp` on Unix isn't always possible since this is usually owned by root.
However, you're usually allowed to make subdirectories in `/tmp` which can be watched.
