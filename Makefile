# ref https://tung.github.io/posts/my-workflow-for-following-crafting-interpreters/
#

src_dir = src/
header_dir = $(src_dir)

build_dir = build/

# MODE variable set to debug(default) or release
ifeq ($(MODE),)
    override MODE = debug
    $(info Using default MODE = $(MODE).)
endif

mode_dir = $(build_dir)$(MODE)/

ifeq ($(MODE),debug)
	CFLAGS = -Wall -Wextra -Og -g -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer
	LDFLAGS = -Og -g -fsanitize=address -fsanitize=undefined
	LDLIBS = -lm
else ifeq ($(MODE),release)
	CFLAGS = -Wall -Wextra -O3 -flto -march=native
	LDFLAGS = -O3 -flto -march=native
	LDLIBS = -lm 
endif

main_name = clox
main_src = $(src_dir)main.c
main_target = $(mode_dir)$(main_name)

objs_dir = $(mode_dir)objs/
deps_dir = $(mode_dir)deps/

# list *.c files
c_srcs = $(wildcard $(src_dir)*.c)
# substitution reference: match each file in c_srcs against the pattern "src/%.c"
# replace non-% parts with the pattern "build/debug/deps/%.d"
c_deps = $(c_srcs:$(src_dir)%.c=$(deps_dir)%.d)
c_objs = $(c_srcs:$(src_dir)%.c=$(objs_dir)%.o)

# Generate *.d files from *.c files
$(c_deps): $(deps_dir)%.d: $(src_dir)%.c
	$(CPP) $(CPPFLAGS) -MM -MT $(@:$(deps_dir)%.d=$(objs_dir)%.o) -MT $@ -MP -MF $@ $<

# Read in *.d files
-include $(c_deps)

# Generate *.o files from *.c files
$(c_objs): $(objs_dir)%.o: $(src_dir)%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

clox: $(c_objs)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

