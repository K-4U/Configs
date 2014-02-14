
class configFile:
    def __init__(self, source, localTarget = "", globalTarget = ""):
        self.source = source
        self.localTarget = localTarget
        self.globalTarget = globalTarget
        if self.localTarget == "" and self.globalTarget == "":
            print("Warning: %s has no local or global target!")

