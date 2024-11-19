using HorizonSideRobots

function do_upora!(robot,side)
    n=0
    while !isborder(robot,side)
        move!(robot,side)
        putmarker!(robot)
        n+=1
    end
    return n
end

function HorizonSideRobots.move!(robot,side,num_steps::Integer)
    for i in 1:num_steps
        move!(robot,side)
    end
end

function inverse(side)
    return HorizonSide(((Int(side))+2)%4)
end

function krest!(robot)
    for side ∈ (Nord,Ost,Sud,West)
        n = do_upora!(robot,side)
        move!(robot,inverse(side),n)
    end
end

