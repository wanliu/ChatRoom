#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com

namespace "ChatRoom.Math", (ex) ->


	#====================================================================================
	# getBezier() - calculates a given position along a Bezier curve specified by 2,3 or
	#               4 control points.
	#====================================================================================

	# Bezier functions:
	B1 = (t) -> t*t*t
	B2 = (t) -> 3*t*t*(1-t)
	B3 = (t) -> 3*t*(1-t)*(1-t)
	B4 = (t) -> (1-t)*(1-t)*(1-t)

	# coordinate constructor
	coord = (x,y) ->  
		x ||= 0; y ||=0
		{x: x, y: y}

	# Finds the coordinates of a point at a certain stage through a bezier curve
	ex.getBezier = (percent,startPos,endPos,control1,control2) ->
		
		control2 = new coord(startPos.x + 3*(endPos.x-startPos.x)/4, startPos.y + 3*(endPos.y-startPos.y)/4) if !control2 && !control1
		control2 = control1 if !control2 
		control1 = new coord(startPos.x + (endPos.x-startPos.x)/4, startPos.y + (endPos.y-startPos.y)/4) if !control1
				
		pos = new coord
		pos.x = startPos.x * B1(percent) + control1.x * B2(percent) + control2.x * B3(percent) + endPos.x * B4(percent)
		pos.y = startPos.y * B1(percent) + control1.y * B2(percent) + control2.y * B3(percent) + endPos.y * B4(percent)

		# pos.x = startPos.x * B1(percent) + endPos.x * B2(percent) + control1.x * B3(percent) + control2.x * B4(percent)
		# pos.y = startPos.y * B1(percent) + endPos.y * B2(percent) + control1.y * B3(percent) + control2.y * B4(percent)
		
		pos	

	ex.getBezierX = (percent,startPos,endPos,control1,control2) ->
		
		# control2 = new coord(startPos.x + 3*(endPos.x-startPos.x)/4, startPos.y + 3*(endPos.y-startPos.y)/4) if control2? && control1?
		# control2 = control1 if control2? 
		# control1 = new coord(startPos.x + (endPos.x-startPos.x)/4, startPos.y + (endPos.y-startPos.y)/4) if control1?
				
		startPos.x * B1(percent) + endPos.x * B2(percent) + control1.x * B3(percent) + control2.x * B4(percent)

	ex.getBezierY = (percent,startPos,endPos,control1,control2) ->
		
		# control2 = new coord(startPos.x + 3*(endPos.x-startPos.x)/4, startPos.y + 3*(endPos.y-startPos.y)/4) if control2? && control1?
		# control2 = control1 if control2? 
		# control1 = new coord(startPos.x + (endPos.x-startPos.x)/4, startPos.y + (endPos.y-startPos.y)/4) if control1?
				
		startPos.y * B1(percent) + endPos.y * B2(percent) + control1.y * B3(percent) + control2.y * B4(percent)
