#11-15

#11

using HorizonSideRobots

r = Robot(animate=true)

mutable struct CheckRobot
    robot::Robot
    f::Bool
end

cr = CheckRobot(robot, false)

function countboarders!(robot)
    num_steps_West = movetoend!(robot, West)
    num_steps_Sud = movetoend!(robot, Sud)
    n = count!(robot)
    movetoend!(robot, West)
    movetoend!(robot, Sud)
    move!(robot, Nord, num_steps_Sud)
    move!(robot, Ost, num_steps_West)
    return n
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot.robot, side)
    end
end

function HorizonSideRobots.move!(robot, side)
    move!(robot.robot, side)
    if !isborder(robot.robot, Nord)
        robot.f || return 0
        robot.f = false
        return 1
    end
    fobot.f = true
    return 0
end

function movetoend!(robot, side)
    n = 0
    while !isborder(robot.robot, side)
        n += move!(robot, side)
    end
    return n
end

inverse(side) = HorizonSide((Int(side) + 2) % 4)

function count!(robot)
    s = Ost
    n = 0
    while !(isborder(robot.robot, Nord) && (isborder(robot.robot, Ost) || isborder(robot.robot, West)))
        n += movetoend!(robot, s)
        move!(robot, Nord)
        s = inverse(s)
    end
    n += movetoend!(robot, s)
    return n
end

#12

using HorizonSideRobots

robot = Robot(animate=true)

mutable struct CheckRobot
    robot::Robot
    f::Bool
    f_ch::Bool
end

cr = CheckRobot(robot, false, false)

function count_boarders!(robot::CheckRobot)
    num_steps_West = do_predela!(robot.robot, West)
    num_steps_Sud = do_predela!(robot.robot, Sud)
    n = podschet!(robot)
    do_predela!(robot.robot, West)
    do_predela!(robot.robot, Sud)
    move!(robot.robot, Nord, num_steps_Sud)
    move!(robot.robot, Ost, num_steps_West)
    return n
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

function do_predela!(robot, side)
    n = 0
    while !isborder(robot, side)
        move!(robot, side)
        n += 1
    end
    return n
end

function podschet!(robot)
    s = Ost
    n = 0
    while true
        n += p_line(robot, s)
        s = inverse(s)
        isborder(robot.robot, Nord) && return n - 1
        move!(robot.robot, Nord)
    end
end

function inverse(side)
    return HorizonSide((Int(side) + 2) % 4)
end

function p_line(robot, side)
    n = 0
    robot.f_ch = false
    while true
        move!(robot.robot, side)
        if isborder(robot.robot, Nord)
            !robot.f && (n += 1)
            robot.f = true
            robot.f_ch = true
        else
            if !robot.f_ch
                robot.f = false
            end
            robot.f_ch = false
        end
        isborder(robot.robot, side) && return n
    end
end

#13

using HorizonSideRobots

robot = Robot(animate=true)

mutable struct R
    robot::Robot
    flag::Bool
end

RR = R(robot, true)

function Chess!(robot)
    num_steps_West = movetoend!(robot, West)
    num_steps_Sud = movetoend!(robot, Sud)
    snake!(s -> isborder(robot.robot, s) && isborder(robot.robot, Nord), robot, (Ost, Nord))
    movetoend!(robot, Ost)
    movetoend!(robot, West)
    movetoend!(robot, Sud)
    move!(robot, Nord, num_steps_Sud)
    move!(robot, Ost, num_steps_West)
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

function HorizonSideRobots.move!(robot::R, side)
    if !isborder(robot.robot, side)
        move!(robot.robot, side)
        robot.flag = !robot.flag
        robot.flag && putmarker!(robot.robot)
    end
end

function movetoend!(robot, side)
    n = 0
    robot.flag && putmarker!(robot.robot)
    while !isborder(robot.robot, side)
        move!(robot, side, 1)
        n += 1
    end
    return n
end

function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide})
    s = sides[1]
    while !stop_condition(s)
        movetoend!(robot, s)
        stop_condition(s) && break
        s = inverse(s)
        move!(robot, sides[2])
    end
end

inverse(side) = HorizonSide((Int(side) + 2) % 4)

#14

using HorizonSideRobots

robot = Robot(animate=true)

struct Coords
    X::Int
    Y::Int
end

mutable struct R
    robot::Robot
    coords::Coords
    scoords::Coords
    mcoords::coords
end

RR = R(robot, Coords(0, 0), Coords(0, 0), Coords(0, 0))

function Chess!(robot::R)
    l, X0, Y0, Xm, Ym = go_to_angle!(robot)
    robot.scoords = Coords(X0, Y0)
    robot.mcoords = Coords(Xm, Ym)
    snake!(s -> isborder(robot.robot, s) && isborder(robot.robot, Nord), robot, (Ost, Nord))
    movetoend!(robot, Ost)
    movetoend!(robot, West)
    movetoend!(robot, Sud)
    for i in reverse(l)
        move!(robot, i[2], i[1])
    end
end

function go_to_angle!(robot::R)
    l = Int[]
    while !(isborder(robot.robot, West) && isborder(robot.robot, Sud))
        push!(l, [movetoend!(robot, West), Ost])
        push!(l, [movetoend!(robot, Sud), Nord])
    end
    X0 = robot.coords.X
    Y0 = robot.coords.Y
    movetoend!(robot, Ost)
    Xm = robot.coords.X
    movetoend!(robot, Nord)
    Ym = robot.coords.Y
    movetoend!(robot, Sud)
    movetoend!(robot, West)
    return l, X0, Y0, Xm, Ym
end

function HorizonSideRobots.move!(robot, side, num_steps)
    for _ in 1:num_steps
        move!(robot, side)
    end
end

function HorizonSideRobots.move!(robot::R, side)
    n = 0
    if !isborder(robot.robot, side)
        move!(robot.robot, side)
        n += 1
        X, Y = robot.coords.X, robot.coords.Y
        side == Nord && Y += 1
        side == Sud && Y -= 1
        side == West && X -= 1
        side == Ost && X += 1
        (X + Y) % 2 == 0 && putmarker!(robot.robot)
        robot.coords = Coords(X, y)
    else
        side == Nord && robot.coords.Y == robot.mcoords.Y && return true, n
        side == Sud && robot.coords.Y == robot.scoords.Y && return true, n
        side == Ost && robot.coords.X == robot.mcoords.X && return true, n
        side == West && robot.coords.X == robot.scoords.X && return true, n
        return false, obhod!(robot, side)
    end
    return false, n
end

function obhod!(robot, side)
    n = 0
    if isborder(robot.robot, side)
        move!(robot, right(side))
        n += obhod!(robot, side)
        move!(robot, left(side))
    else
        move!(robot, side)
        n += 1
        isborder(robot.robot, left(side)) && (n += obhod!(robot, side))
    end
    return n
end

right(side) = HorizonSide((Int(side) + 1) % 4)
left(side) = HorizonSide((Int(side) + 3) % 4)


function movetoend!(robot::R, side)
    n = 0
    X, Y = robot.coords.X, robot.coords.Y
    (X + Y) % 2 == 0 && putmarker!(robot.robot)
    while true
        f, num = move!(robot, side)
        n += num
        f && break
    end
    return n
end

function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide})
    s = sides[1]
    while !stop_condition(s)
        movetoend!(robot, s)
        stop_condition(s) && break
        s = inverse(s)
        move!(robot, sides[2])
    end
end

inverse(side) = HorizonSide((Int(side) + 2) % 4)

