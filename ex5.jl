using HorizonSideRobots
robot = Robot(animate=true,8,8)
inverse(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)
turn_right(side::HorizonSide) = HorizonSide((Int(side) + 3) % 4)

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)
    end
end


function FindBox!(robot)
    side = Nord
    while !isborder(robot, Ost)
        move!(robot, side)
        if isborder(robot, Nord) || isborder(robot, Sud)
            side = inverse(side)
            move!(robot, Ost)
        end
    end
end


function FillArea!(robot)
    side = Nord
    while !ismarker(robot)
        while isborder(robot, turn_right(side)) && !ismarker(robot)
            putmarker!(robot)
            move!(robot, side)
        end
        if ismarker(robot)
            break
        end
        side = turn_right(side)
        putmarker!(robot)
        move!(robot, side)
    end
end


function crossToBegin!(robot)
    x, y = 0, 0
    while !isborder(robot, West) || !isborder(robot, Sud)
        if !isborder(robot, West)
            move!(robot, West)
            x -= 1
        end
        if !isborder(robot, Sud)
            move!(robot, Sud)
            y -= 1
        end
    end
    return x, y
end


function GoToPoint(robot, x, y) 
    while x != 0 || y != 0
        if isborder(robot, Nord)
            x += 1
            move!(robot, Ost)
        elseif x < 0 && !isborder(robot, Ost)
            x += 1
            move!(robot, Ost)
        elseif x > 0 && !isborder(robot, West)
            x -= 1
            move!(robot, West)
        end
        if isborder(robot, Ost)
            y += 1
            move!(robot, Nord)
        elseif y < 0 && !isborder(robot, Nord)
            y += 1
            move!(robot, Nord)
        elseif y > 0 && !isborder(robot, Sud)
            y -= 1
            move!(robot, Nord)
        end
    end
end

function perimetr(robot)
    for side in (Nord,Ost,Sud,West)
        while !isborder(robot, side)
            putmarker!(robot)
            move!(robot,side)
        end 
    end 
end


function cross!(robot)
    x, y = crossToBegin!(robot)
    FindBox!(robot)
    FillArea!(robot)
    crossToBegin!(robot)
    GoToPoint(robot, x, y)
    perimetr(robot)
end
