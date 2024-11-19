#Маркеры по периметру

using HorizonSideRobots
robot = Robot(animate=true,8,8)
function do_upora!(robot)
    while !isborder(robot,West)
        move!(robot,West)
    end
    while !isborder(robot,Sud)
        move!(robot,Sud)
    end
end

function go(robot)
    do_upora!(robot)
    while !isborder(robot,Ost)
        while !isborder(robot,Nord)
            putmarker!(robot)
            move!(robot,Nord)
            putmarker!(robot)
        end
        move!(robot,Ost)
        while !isborder(robot,Sud)
            putmarker!(robot)
            move!(robot,Sud)
            putmarker!(robot)
        end
    end
end

