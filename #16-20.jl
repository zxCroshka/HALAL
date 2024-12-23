#16-20
#ЗАГРУЗИЛ СЮДА ВСЕ КОТОРЫЕ СДЕЛАЛ. БУДУ РАД ЕСЛИ УЧТЕТЕ ЕЩЕ И ИХ КАК РЕШЕННЫЕ. НЕКОТОРЫЕ НЕ СДЕЛАЛ, Т К СОБИРАЛСЯ СДЕЛАТЬ В ПОСЛЕДНЮЮ НЕДЕЛЮ, ТК В ТЕХ ЖЕ 16-18 ЗАДАЧАХ МУСОЛЯТ 
#ОДНУ ТЕМУ И ПО ЭТОМУ Я РЕШИЛ СДЕЛАТЬ ИХ В ПОСЛЕДНЮЮ ОЧЕРЕДЬ

#19
function movetoend!(robot, side)
    isborder(robot, side) && return nothing
    move!(robot, side)
    movetoend!(robot, side)
end

#20

function movetoendplusmarker!(robot, side)
    if isborder(robot, side)
        putmarker!(robot, side)
        return nothing
    end
    move!(robot, side)
    movetoendplusmarker!(robot, side)
    move!(robot, HorizonSide((Int(side) + 2) % 4))
end

#21

function move_boarder!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        movetocondition!(() -> !isborder(robot, left(side)), robot, side)
        return nothing
    end
    move!(robot, right(side))
    move_boarder!(robot, side)
    move!(robot, left(side))
end

left(side) = HorizonSide((Int(side) + 1) % 4)

right(side) = HorizonSide((Int(side) + 3) % 4)

function movetocondition!(stop_condition::Function, robot, side)
    while !stop_condition()
        move!(robot, side)
    end
end

#22
using HorizonSideRobots

robot = Robot(animate=true)

function go!(robot, side, count)
    if !isborder(robot, side)
        move!(robot, side)
        n = go!(robot, side, count + 1)
    else
        move!(robot, inverse(side), count)
        n = move!(robot, inverse(side), count)
    end
    return n
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for i in 1:num_steps
        if isborder(robot, side)
            move!(robot, inverse(side), i - 1)
            return false
        else
            move!(robot, side)
        end
    end
    return true
end

inverse(side) = HorizonSide((Int(side) + 2) % 4)

#23

using HorizonSideRobots

robot = Robot(animate=true)

function move_symmetry!(robot, side)
    if isborder(robot, side)
        move_border!(robot, side)
        return nothing
    else
        move!(robot, side)
        move_symmetry!(robot, side)
        move!(robot, side)
    end
end

function move_border!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        movetoend!(() -> !isborder(robot, left(side)), robot, side)
        return nothing
    end
    move!(robot, right(side))
    move_border!(robot, side)
    move!(robot, left(side))
end

left(side) = HorizonSide((Int(side) + 1) % 4)

right(side) = HorizonSide((Int(side) + 3) % 4)

function movetoend!(stop_condition::Function, robot, side)
    while !stop_condition()
        move!(robot, side)
    end
end

#24
using HorizonSideRobots

robot = Robot(animate=true)

function go!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        return movebool!(robot, inverse(side), go!(robot, side))
    else
        return true
    end
end

function movebool!(robot, side, flag)
    flag || return true
    move!(robot, side)
    return false
end

inverse(side) = HorizonSide((Int(side) + 2) % 4)

#25a

using HorizonSideRobots

robot = Robot(animate=true)

function chess_line!(robot, side)
    putmarker!(robot)
    isborder(robot, side) && return nothing
    move!(robot, side)
    chess_line_1!(robot, side)
end

function chess_line_1!(robot, side)
    isborder(robot, side) && return nothing
    move!(robot, side)
    chess_line!(robot, side)
end

#25b

using HorizonSideRobots

robot = Robot(animate=true)

function chess_line!(robot, side)
    isborder(robot, side) && return nothing
    move!(robot, side)
    chess_line_1!(robot, side)
end

function chess_line_1!(robot, side)
    putmarker!(robot)
    isborder(robot, side) && return nothing
    move!(robot, side)
    chess_line!(robot, side)
end

#26

using HorizonSideRobots

robot = Robot(animate=true)

function labirint!(robot)
    ismarker(robot) && return nothing
    putmarker!(robot)
    for s in (Nord, West, Sud, Ost)
        if !isborder(robot, s)
            move!(robot, s)
            labirint!(robot)
            move!(robot, inverse(s))
        end
    end
end

inverse(side) = HorizonSide((Int(side) + 2) % 4)

#28a
function Fib(n::Int)
    n <= 2 && return 1
    a, b = 1, 1
    for i in 1:n-1
        (i % 2 == 0) && (b = a + b)
        (i % 2 == 1) && (a = a + b)
    end
    return max(a, b)
end

#28b

function Fib1(n::Int)
    n == 1 || n == 2 || return Fib(n - 1) + Fin(n - 2)
    return 1
end

#29a

using HorizonSideRobots

robot = Robot(animate=true)

function labirint!(robot)
    imarker(robot) && return nothing
    putmarker!(robot)
    for s in (Nord, West, Sud, Ost)
        move!(robot, s)
        labirint!(robot)
        move!(robot, inverse(s))
    end
end

inverse(side) = HorizonSide((Int(side) + 2) % 4)


#29b-то же самое что и #26

#30

robot = Robot(animate=true)

struct Coordinates
    x::Int
    y::Int
end

mutable struct Coord_Robot
    robot::Robot
    coord::Coordinates
end

function move(coord::Coordinates, side)
    x = coord.x
    y = coord.y
    side == Nord && y += 1
    side == Sud && y -= 1
    side == Ost && x += 1
    side == West && x -= 1
    return Coordinates(x, y)
end

function HorizonSideRobots.move!(robot::Coord_Robot, side)
    isborder(robot.robot, side) && return false
    move!(robot.robot, side)
    robot.coord = move(robot.coord, side)
    return true
end

struct LRobot
    c_robot::Coord_Robot
    passed_c::Set{Coordinates}
    LRobot(robot::Robot) = new(Coord_Robot(robot, Coordinates(0, 0)), Set{Coordinates})
end

R = LRobot(robot)

function labirint!(action::Function, robot::LRobot)
    ((robot.c_robot.coord in robot.passed_c) || ismarker(robot.c_robot.robot)) && return nothing
    push!(robot.passed_c, robot.c_robot.coord)
    action()
    for side in (Nord, West, Sud, Ost)
        move!(robot.c_robot, side) && begin
            labirint!(action, robot)
            move!(robot.c_robot, inverse(side))
        end
    end
end

inverse(side) = HorizonSide((Int(side) + 2) % 4)

function chess!(robot::LRobot)
    x = robot.c_robot.coord.x
    y = robot.c_robot.coord.y
    (((x + y) % 2) == 0) && putmarker!(robot.c_robot.robot)
end

task30!(robot::LRobot) = labirint!(() -> chess!(robot), robot)