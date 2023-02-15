:- dynamic(add_student/3).
:- dynamic(student/3).
:- dynamic(room/3).
:- dynamic(add_room/3).
:- dynamic(course/7).
:- dynamic(add_course/7).
:- dynamic(instructor/3).
:- style_check(-singleton).

% knowledge base

%	Course
%	ID		Instructor	Capacity	Hour	Room
%	CSE341	YG			10		 4		Z06
%	CSE102	YG			15		 4		Z06
%	CSE342	YSA			6		 3		Z11

% instructor(id,[given courses],[preferences]).
instructor(YG,[cse341,cse102],[projector,smartboard]).
instructor(YSA,[cse342],[smartboard]).

% course(ID,instructor,capacity,[students],hour,room,[needs]).
course(cse341,YG,10,[s1,s3],4,z06,[projector,smartboard,handicapped]).
course(cse102,YG,15,[s2],4,z06,[projector,smartboard]).
course(cse342,YSA,6,[s2,s3],3,z11,[smartboard,handicapped]).

% room(ID,capacity,[equipment]).
room(z06,10,[projector,smartboard,handicapped]).
room(z11,15,[projector,smartboard,handicapped]).
room(z10,10,[projector,smartboard]).

% student(ID,[taken courses],Handicapped).
student(s1,[cse341],no).
student(s2,[cse342,cse102],no).
student(s3,[cse342,cse341],handicapped).

% occupancy(ID,Hour,CourseID).
occupied(cse341,z06,8).
occupied(cse341,z06,9).
occupied(cse341,z06,10).
occupied(cse341,z06,13).

occupied(cse102,z06,10).
occupied(cse102,z06,11).
occupied(cse102,z11,12).
occupied(cse102,z11,13).

occupied(cse342,z11,10).
occupied(cse342,z11,11).
occupied(cse342,z11,12).

% rules

%For Adding Student
add_student(ID,Courses,Handicapped):-
    \+student(ID,_,_),
    assertz(student(ID,Courses,Handicapped)).

%For Adding room
add_room(ID,Capacity,Equipments):-
    \+room(ID,_,_),
    assertz(room(ID,Capacity,Equipments)).
    
%For Adding Course
add_course(ID,Instructor,Capacity,Students,Hour,Room,Equipments):-
    \+course(ID,_,_,_,_,_,_),
    assertz(course(ID,Instructor,Capacity,Students,Hour,Room,Equipments)).

conflict(Course1, Course2):- occupied(Course1,C,T1), occupied(Course2,C,T2), not(Course1=Course2),
                            (T1=T2 -> (write("Conflict at room: "), write(C), write(" At hour: "), write(T1)) ; write("No conflict\n")).

% Check which room can be assigned to a course
assign(Course) :- course(Course,I,C1,H,_,R1,N), 
                    room(R, C2, E),
                    C1 =< C2, (subset(N,E) -> (write("Can assign to room: "), write(R)) ; write("Can assign to room: NONE\n")).

% Define a predicate that prints a suitable room for a class
print_room(Course) :- write(Course), write(" "), assign(Course), nl.

% Define a predicate that prints suitable rooms for all classes
% use this for testing
print_rooms :-
    findall(Course, course(Course, _, _, _, _, _, _), Courses),
    maplist(print_room, Courses).


% Check whether a student can be enrolled to a given class
student_class(Student, Course) :- student(Student, _, Needs), course(Course, _, C, S, _, _, Equipments), 
                                length(S, NumStudents), NumStudents + 1 =< C,
                                (Needs == no -> true ; in(Needs, Equipments)).


% Check which classes a student can be assigned.
% have to specifically enter the student id for this
student_check(Student) :-
    findall(Course, course(Course, _, _, _, _, _, _), Courses),
    findall(Course, (member(Course, Courses), student_class(Student, Course)), Coursess),
    write(Student), write(" : "), write(Coursess), nl.


% To check whether an element is in a list
in(Elem, List) :- member(Elem, List).

% To check whether a list is a subset of another list
subset(Sub, List) :- forall(member(Elem, Sub), member(Elem, List)).

% To check whether an element is in a list
element(Elem, List) :- member(Elem, List).
