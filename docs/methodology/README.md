# methodology

Explore the methodology and documentation practices to better move this endeavor along.

## 2025-02-03

In the most recent test, it has not been possible to provoke corruption using the S/W versions from the original issue after running for over 1100 `syncoid` invocations. At this point I am stepping back to try for some improvements.

1. The first priority is to explore the test methodology to see if results can be achieved in less time.
1. The second priority is to standardize the testing procedure and recording policies to provide more reliable results in a manner that is easier to view (IOW, It's hard find the details of stuff I did weeks ago!)
1. To facilitate the previous, The notes will be organized such that they can be processed using `mkdocs`.

### Organization

"Test cases" will be listed in the README in `.../provoke_ZFS_corruption/docs/tests` and will include 

* date started
* date completed
* results
* link to test_setup description
* ZFS version or commit hash (and whether or not from backports, release, etc.)
* OS variant (e.g. Buster, Bullseye, Bookworm)
* kernel version (and whether or not from backports.)


Each "test case" will have a set of files in it's own directory named starting with the date in ISO-8601 format (e.g. `2025-02-03_test`)

* `setup.md` Commands required to set up the test and kick it off along with any relevant results. The markdown title will include the date string and "setup" (e.g. `# 2025-02-03 Setup`, first line in the file.)
* `results.md` Copies of text from the screen for anything that might be worthy of later review. `results.md` and `setup.md` sho0uld link to each other.
* `[anything else useful]` as the sitruation warrants.