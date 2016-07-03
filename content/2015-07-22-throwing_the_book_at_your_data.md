Title: Throwing the Book at Your Data
Date: 2015-07-22 7:42
Author: Michelle Gill
Slug: throwing_the_book_at_your_data
Tags: python, science, openscience, shell


You may have noticed all has been quiet on the blog front from me lately. There are several reasons for this,[^move_five_papers] but I can assure you it isn't for lack of things to write about. Today, I'm happy to share with you one of the projects that has been keeping me busy. I am writing a book about one of my favorite topics: Python!

The book is entitled "Unix and Python to the Rescue!" and you can read more about it on the [official website](http://rescuedbycode.com). As you will [notice](http://rescuedbycode.com/about-the-authors), I'm not writing the book alone. I am fortunate to be working with Keith Bradnam and Ian Korf, who are both seasoned veterans of the computational book authorship world.[^perl_book] Keith and Ian work at the UC Davis Genome Center, where Keith is an Associate Project Scientist and Ian is a Professor. You can read more about Keith, including his [announcement](http://www.acgt.me/blog/2015/7/20/taking-steps-to-write-a-new-book-about-programming) of our book on his excellent blog, [ACGT](http://www.acgt.me).

## Do we really need another book on Python? ##

There are quite a few books on the topic of Python programming, many of which are excellent, so you may be asking yourself why we need another one. Keith, Ian, and I asked ourselves this when we discussed writing the book. However, I believe the goals of this book, which I've paraphrased from the book's announcement, fill a niche in the Python programming world:

1. Introduce both Unix & Python assuming no prior knowledge of either
2. Include both basic and more advanced topics that are relevant to scientists
3. Whenever possible, make topics "digestible" by introducing only one new concept at a time
4. Maintain an engaging and fun style

For a book with this focus, I think it is particularly important to cover both Unix and Python because it's nearly impossible to use the later with some knowledge of the former. And there are many times when a few Unix commands can provide a quick answer to help you decide if more in-depth analysis with Python is appropriate. 

## Why should life scientists learn to code? ##

Another great question. Scientists are busy people and there are many data analysis tools available that don't require learning how to program. However, it is my belief--based on my own experience--that using a prefabricated tool, such as a spreadsheet or graphing program, inherently limits you to someone else's idea of what analytical questions you should be asking about your data. In today's scientific world, the amount and type of data we need to understand changes rapidly, and these programs can quickly become limiting. By taking the time to learn a set of basic tools that can be combined in limitless ways,[^unix_philosophy] you empower yourself to ask the kind of analytical questions *you* want to ask about your data.

I also strongly believe in using open source tools, like Unix and Python, because of their accessibility and relative permanence. I have personally been faced with the decision of how to proceed with data analysis when university administration failed to renew a software license before it expired.[^learn_python] I have also assisted other scientists who've had data trapped in an unreadable file format because they no longer have access to the program that created the files. I think situations such as these are unacceptable. Even if Python development ceased completely tomorrow,[^worst_case] the code would still compile and run on computers for several years to come, allowing time to transition to something new. More importantly, all your data and analyses will remain in an accessible (readable) format indefinitely.

## What now? ##

Mostly lots of writing and editing! I will also be joining Keith in tweeting from the [@rescuedbycode](https://twitter.com/rescuedbycode) Twitter account. We look forward to sharing Python tips and chatting with you there.

[^move_five_papers]: Nothing eats up your free time like moving to a new city and submitting five publications, all in one year.

[^perl_book]: Keith and Ian wrote ["Unix and Perl to the Rescue!"](http://rescuedbycode.com/unix-and-perl-book), which is in some ways a cousin to our current efforts.

[^unix_philosophy]: This is part of the [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy).

[^learn_python]: This experience is actually what prompted me to learn Python. Fortunately, I already had some programming knowledge and was at a position in my career where I was able to spend a little time learning a new language.

[^worst_case]: I certainly hope this never happens, but for the sake of exploring worst case scenarios, let's consider it.
