function parsexml11(dir::String)
    for file in readdir(dir)
        
    end

    xml = readxml(path)
    arxivs = find(xml, "//arXiv")
    for arxiv in arxivs
        id = "arXiv" * nodecontent(findfirst(arxiv,"./id"))
        title = nodecontent(findfirst(arxiv,"./title"))
        abst = nodecontent(findfirst(arxiv,"./abstract"))

        doc = """
        <?xml version="1.0" encoding="UTF-8"?>
        <article>
        <front>
        <id>$id</id>
        <journal-title>arXiv</journal-title>
        <article-title>$title</article-title>
        <year>2016</year>
        <abstract>
        <p>$(strip(abst))</p>
        </abstract>
        </article>
        """

        #dir = joinpath()
        #isdir(dir) || mkdir(dir)
        #open(io -> print(io,doc), "$dir", "w")
    end
end
