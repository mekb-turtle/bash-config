#include <stdio.h>
#include <unistd.h>
int main(int argc, char* argv[]) {
	if (argc != 2) return 1;
	char* args[] = {
		"/usr/bin/bash",
		"-c",
		"[[ ! -e \"$1\" ]] && exit 1; TMP=\"$(mktemp)\"; col -b < \"$1\" > \"$TMP\" && nvim -MR -- \"$TMP\"",
		"manpager",
		argv[1],
		NULL
	};
	execvp(args[0], args);
}
