using HorizonSideRobots
r = Robot(animate=true,9,9)

function do_predela(r,side)
    n = 0
    while !isborder(r,side)
        move!(r,side)
        n+=1
    end
    return n 
end 
function HorizonSideRobots.move!(r,side,num_steps)
    for i in 1:num_steps
        move!(r,side)
    end
end 


function chess(r)
    n = 0
    num_steps_left = do_predela(r,West)
    num_steps_down= do_predela(r,Sud)
    n+= (num_steps_left+ num_steps_down)%2
    chess_new(r,n)
    do_predela( r,West)
    do_predela(r,Sud)
    move!(r,Nord,num_steps_down)
    move!(r,Ost, num_steps_left)
end

function inverse(side)
    return HorizonSide((Int(side)+2)%4)
end 

function chess_new(r,n)
    side = Ost
    k=n
    while !isborder(r,Nord)
        while !isborder(r,side) 
            if (k%2)==0
                putmarker!(r)
            end
            move!(r,side)
            k= (k+1)%2
        end
        if (k%2)==0
            putmarker!(r)
        end
        move!(r,Nord)
        k = (k+1)%2
        side = inverse(side)
    end
    while !isborder(r,side) 
        if (k%2)==0
            putmarker!(r)
        end
        move!(r,side)
        k= (k+1)%2
    end
    if (k%2)==0
        putmarker!(r)
    end
    k = (k+1)%2
    side = inverse(side)
end

