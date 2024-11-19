using HorizonSideRobots

r = Robot(animate=true, 12,12)

function sideplusodin(side)
    return HorizonSide(((Int(side) + 1) % 4) )
end 

function gogo(r)
    n = 1
    side = Nord
    while !ismarker(r)
        for i in 1:n
            if ismarker(r)
                break
            end
            move!(r, side)
        end
        
        side = sideplusodin(side)
        for i in 1:n
            if ismarker(r)
                break
            end
            move!(r, side)
        end
        
        side = sideplusodin(side)
        n += 1
    end
end
