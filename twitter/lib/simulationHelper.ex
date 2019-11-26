defmodule Twitter.Simulator.Helper do

 def generateUserId(i) do
   "user" <> "" <> Integer.to_string(i+1)
 end

 def generatePassword(i) do
    "pwd" <> "" <> Integer.to_string(i+1)
 end

 def generateMail(i) do
    "user" <> "" <> Integer.to_string(i+1) <> "@email.com"
 end

end
