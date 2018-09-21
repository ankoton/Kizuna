
CXX := clang++
CXXFLAGS := -std=c++2a -Weverything -Wno-c++98-compat-pedantic -pedantic-errors -O2 -pipe -MMD -MP
CPPFLAGS :=
LDFLAGS :=
INCLUDES := -I ./include
LIBS :=

RM := rm -fv
MKDIR := mkdir -p

BINDIR := ./bin
BUILDDIR := ./build
OBJDIR := $(BUILDDIR)
SRCDIR := ./src

SRCS := $(wildcard $(SRCDIR)/*.cpp)

# ./src/*.cpp => ./build/*.o
OBJS := $(subst $(SRCDIR)/,$(OBJDIR)/, $(SRCS:.cpp=.o))

# ./build/*.o => ./build/*.d
DEPENDS := $(OBJS:.o=.d)

# exeutable file
TARGET := $(BINDIR)/a.out

all: $(TARGET)

debug:
	$(MAKE) CPPFLAGS+=-DDEBUG

$(TARGET): $(OBJS) $(LIBS)
	@$(MKDIR) $(BINDIR)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(LDFLAGS)

# compile ./*.cpp => ./*.o
%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(INCLUDES) -o $@ -c $<

# compile ./src/*.cpp => ./build/*.o
$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	@$(MKDIR) $(OBJDIR)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(INCLUDES) -o $@ -c $<

clean:
	$(RM) $(OBJS) $(DEPENDS) $(TARGET)

run: $(TARGET)
	$(TARGET)

pretend:
	$(MAKE) -n

-include $(DEPENDS)

.PHONY: all clean run pretend debug release
