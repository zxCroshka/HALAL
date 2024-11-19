using HorizonSideRobots
r = Robot(animate=true,10,10)

function HorizonSideRobots.move!(robot,side,num_steps::Integer)
    for i in 1:num_steps
        move!(robot,side)
    end
end 

function inverse(side)
    return HorizonSide(((Int(side))+2)%4)
end
function left_right(r)
    n = 0
    side = West
    if !isborder(r,Nord)
        move!(r,Nord)
    end
    while isborder(r,Nord)
        move!(r,side)
        if !isborder(r,Nord)
            move!(r,Nord)
        else
            side = inverse(side)
            n+=1
            move!(r,side,n)
        end
    end
end

#идея маятника
