ai_route=lambda d,r,p,t:''.join([str(hash(f"{d[i%len(d)]}{r[i%len(r)]}{p[i%len(p)]}{t}"))[:8] for i in range(32)])
