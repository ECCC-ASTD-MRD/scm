Single Column Model (SCM) driver for RPNPhy: RPN, MRD, STB, ECCC, GC, CA
========================================================================

This document is intended as a notebook and checklist for the SCM
librarian. It is only valid on EC/CMC and GC/Science Networks.

Updating the scm depot for a release
===========================================

# Steps to be done in a SCM dev env.

... include code from contrubutors & test ...
... see with RPN-SI if there are updates needed to the CMakeLists.txt ...

Closing Issues
==============

**TODO**: review/close bugzilla issues


Tests
=====

Make sure to test with GFortran and intel

1st shell
```
. .ssmuse_scm intel
. .intial_setup
make cmake
make -j4
make work
# ... run tests...
```

2nd shell
```
. .ssmuse_scm gnu
. .intial_setup
make cmake
make -j4
make work
# ... run tests...
```

Finalize
========

# Steps to be done in a GEM dev env.

# Update MANIFEST for VERSION and dep.
```
emacs src/rpnphy/MANIFEST
```

# Update versions_components file from MANIFEST info
```
emacs share/scm_versions_components.txt
```

# tag
git tag scm_VERSION

# Push on gitlab
git push git@gitlab.science.gc.ca:MIG/scm.git
git push --tags git@gitlab.science.gc.ca:MIG/scm.git


Documentation update
--------------------

**TODO**: review doc on wiki





Misc
====

Patching the git repo
---------------------

Ref: https://www.devroom.io/2009/10/26/how-to-create-and-apply-a-patch-with-git/

Patch are produced with:

       BASETAG=   #Need to define from what tag (or hash) you want to produce patches
       git format-patch HEAD..${BASETAG}

Before applying the patch, you may check it with:

       git apply --stat PATCH.patch
       git apply --check PATCH.patch

Full apply

       git am --signoff PATCH.patch

Selective application, random list of commands

       git apply --reject PATH/TO/INCLUDE PATCH.patch
       git apply --reject --include PATH/TO/INCLUDE PATCH.patch
       git am    --include PATH/TO/INCLUDE  PATCH.patch
       git apply --exclude PATH/TO/EXCLUDE PATCH.patch
       git am    --exclude PATH/TO/EXCLUDE  PATCH.patch

Fixing apply/am problems

Ref: https://stackoverflow.com/questions/25846189/git-am-error-patch-does-not-apply
Ref: https://www.drupal.org/node/1129120

With --reject: 

  * inspect the reject
  * apply the patch manually (with an editor)
  * add file modified by the patch (git add...)
  * git am --continue
