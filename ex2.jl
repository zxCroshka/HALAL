using HorizonSideRobots
robot = Robot(animate=true,8,8)
function do_upora!(robot,side)
    count=0
    while !isborder(robot,side)
        move!(robot,side)
        count+=1
    end
    return count
end

function go(robot)
    num_steps_sud  = do_upora!(robot,Sud)
    num_steps_west  = do_upora!(robot,West)
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
    while !isborder(robot,West)
        move!(robot,West)
    end
    move!(robot, Nord, num_steps_sud)
    move!(robot,Ost,num_steps_west)
end
