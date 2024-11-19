using HorizonSideRobots
robot = Robot(animate=true)

function untildawn(robot , side)
    k = 0 
    while !isborder(robot, side)
        move!(robot, side)
        k+=1
    end
    putmarker!(robot)
    return k
end
function untildawn1(robot , side)
    k = 0 
    while !isborder(robot, side)
        move!(robot, side)
        k+=1
    end
    return k
end



function perimetra(robot)
    height = 0
    sideln = 0
    while (!isborder(robot, Nord) || !isborder(robot, Ost))
        while !isborder(robot, Nord)
            move!(robot, Nord)
            height += 1
        end
        while isborder(robot, Nord)
            if !isborder(robot, Ost)
                move!(robot, Ost)
                sideln += 1
            else
                break
            end
        end

    end
    untildawn(robot, Sud)
    untildawn(robot, West)
    untildawn(robot, Nord)
    untildawn(robot, Ost)
    move!(robot, West, sideln)
    n = 0
    z = 0
    while n!= height
        while !isborder(robot, Sud)
            n+=1
            if n > height
                break
            end
            move!(robot, Sud)
            if n == height
                break
            end
        end
        otstup = 0
        if n == height
            break
        end
        while isborder(robot, Sud)
            if !isborder(robot, Ost)
                move!(robot, Ost)
                z+=1
                otstup += 1
            else
                break
            end
        end
        move!(robot, Sud)
        n+=1
        if n == height
            break
        end
        while isborder(robot, West)
            move!(robot, Sud)
            n+=1
            if n == height
                break
            end
        end
        move!(robot, West, z)
        z = 0
        if n == height
            break
        end
    end
end

function perimetrb(robot)
    height = 0
    sideln = 0
    while (!isborder(robot, Nord) || !isborder(robot, Ost))
        while !isborder(robot, Nord)
            move!(robot, Nord)
            height += 1
        end
        while isborder(robot, Nord)
            if !isborder(robot, Ost)
                move!(robot, Ost)
                sideln += 1
            else
                break
            end
        end

    end
    move!(robot, West, sideln)
    putmarker!(robot)
    move!(robot, Ost, sideln)
    move!(robot, Sud, height)
    putmarker!(robot)
    sud = untildawn1(robot, Sud)
    move!(robot, West, sideln)
    putmarker!(robot)
    west = untildawn1(robot, West)
    move!(robot, Nord, sud)
    putmarker!(robot)
    untildawn1(robot, Nord)
    untildawn1(robot, Ost)
    move!(robot, West, sideln)
    n = 0
    z = 0
    while n!= height
        while !isborder(robot, Sud)
            n+=1
            if n > height
                break
            end
            move!(robot, Sud)
            if n == height
                break
            end
        end
        otstup = 0
        if n == height
            break
        end
        while isborder(robot, Sud)
            if !isborder(robot, Ost)
                move!(robot, Ost)
                z+=1
                otstup += 1
            else
                break
            end
        end
        move!(robot, Sud)
        n+=1
        if n == height
            break
        end
        while isborder(robot, West)
            move!(robot, Sud)
            n+=1
            if n == height
                break
            end
        end
        move!(robot, West, z)
        z = 0
        if n == height
            break
        end
    end
end
