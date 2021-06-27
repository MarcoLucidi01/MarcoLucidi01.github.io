2021-06-20

smartctl short self test very slow on a new drive
=================================================

I recently bought a new 4TB hard drive for my (homemade) nas and started setting
it up. I created a partition table with a single partition and an `ext4`
filesystem. I then `mount`ed the partition, but before starting `rsync`ing my
data, I wanted to do a little [S.M.A.R.T. testing][1]. the drive only supports
_short_ and _long_ self tests, no _conveyance_. I went for the short one since
I'm not very paranoid and I already have `smartd` setup to run tests weekly on
all the nas's disks.

`smartctl` was so kind to tell me that the test will be completed in 2 minutes:

    Testing has begun.
    Please wait 2 minutes for test to complete.
    Test will complete after Fri Jun 18 18:34:03 2021 CEST
    Use smartctl -X to abort test.

I listened to a song while waiting. 5 minutes goes by, song is over, let me
check:

    Self-test execution status:      ( 241) Self-test routine in progress...
                                            10% of test remaining.

ok, 10% remaining, we are almost there. let's wait. and 10 minutes goes by,
still 10% remaining. 20 minutes, still 10% remaining. 25 minutes, still 10%. it
seems to be stuck! it should have completed in 2 minutes, but half an hour has
passed and it still hasn't finished.

I was ninety percent sure that I ran the short test, not the long one. I aborted
the test with `smartctl -X` and this ugly line got into the self test log:

    Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
    ...
    # 9  Short offline       Aborted by host               10%         0         -

which confirmed that it was indeed a _short_ test.

why was it taking so long? faulty disk?

I ran the short test again hoping this time it would finish in a reasonable
amount of time. same story, stuck at 10% remaining after more than 20 minutes. I
then decided to use one of the old tricks that _always_ works with technology: I
rebooted the machine... boom, another nasty line in the log:

    # 8  Short offline       Interrupted (host reset)      10%         1         -

I started the test again. meanwhile my _google-fu_ wasn't helping much, everyone
talked about **long** tests being slow, 30+ hours on old disks that were about
to fail. my disk is new, all the smart attributes are perfect. then I read
somewhere that if the disk is doing a lot of I/O i.e.  is being used, the tests
may take longer. ok, makes sense, but there is no data on my disk and no service
is using it yet.

I felt a bit discouraged, maybe I had to return this drive and wait for another
one to arrive etc...

as a last resort, I tried to `umount` the partition thinking that somehow it
could help. **10 seconds later the test completed without errors**:

    # 7  Short offline       Completed without error       00%         2         -

woow! coincidence? at least the disk seems to be good. I immediately started
another short test and completed without errors in 2 minutes!

    # 6  Short offline       Completed without error       00%         2         -

ok, tests takes long **only** when it's mounted. strange because _nobody_ is
using the disk (or at least that's what I believed). I thought: "maybe I did
something wrong when I partitioned the disk" and I repartitioned it again,
`mount`ed again aaand test stuck at 10% remaining.

I didn't know what to do, I wasn't quite sure that the disk was OK and that it
was _safe_ to put data on it. I fired up `top`** and stared at it for a while
thinking, like when you open the hood of a car trying to figure out what's
wrong. now with cars, that never helped me because I know nothing about cars,
but with computers sometimes it does help. I noticed this process that kept
popping up: `ext4lazyinit`. mmmm never heard of it, but the name was suspicious.
I found [this beautiful page][2] which talks about lazy initialization in `ext4`
filesystems (emphasis mine):

> When creating an Ext4 file system, the existing regions of the inode tables
> must be cleaned (overwritten with nulls, or "zeroed"). The "lazyinit" feature
> should significantly accelerate the creation of a file system, because it does
> not immediately initialize all inode tables, initializing them gradually
> instead during the initial mounting process in background
> ...
> **The "ext4lazyinit" kernel process writes at up to 16,000kB/s to the device
> and thereby uses a great deal of the hard disk’s bandwidth**

aaaha so maybe this is the process that is keeping my disk busy and it's slowing
down short self tests! to prove this theory I recreated the filesystem _again_
using these extended options:

    # mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0 /dev/sda1

> By specifying these options, the inodes and the journal will be initialized
> immediately during creation.

filesystem creation took quite a while this time, but in the end, no more
`ext4lazyinit` process and short smart self test completed in about 2 minutes
even with the partition mounted:

    # 3  Short offline       Completed without error       00%         3         -
    # 4  Short offline       Completed without error       00%         3         -
    # 5  Short offline       Completed without error       00%         3         -

another solution was probably to _just wait_ and eventually short tests would
complete rather fast once the disk was no more busy. at least, my "impatience"
let me figure out what was really happening and learn new things which is always
good!

[1]: https://en.wikipedia.org/wiki/S.M.A.R.T.#Self-tests
[2]: https://www.thomas-krenn.com/en/wiki/Ext4_Filesystem#Lazy_Initialization

---

<small>** only later I discovered `iotop` which would have helped a lot.</small>
