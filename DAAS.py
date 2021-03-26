
def fw (**kargs):

    ## For DAAS
    if (len(kargs.get('tables'))) == 1 :
        x = "SELECT * FROM {}".format(kargs['tables'][0])
        print (x)
        #spark.sql (x)


    ## For CAAS
    else:
        if len(kargs['tables']) != len(kargs['linkage']) + 1:
            print('Discrepancy in number of links and tables provided')

        else:
            #print('SELECT * FROM {} INNER JOIN {} ON {}'.format(kargs['tables'][0],kargs['tables'][1],kargs['linkage'][0]))

            for i in range(len(kargs['linkage'])):
                y = 'SELECT * FROM {} INNER JOIN {} ON {}'.format(kargs['tables'][i], kargs['tables'][i + 1], kargs['linkage'][i])
                print(y)
                #spark.sql(y)

fw(tables =['t1','t2','t3'], linkage= ['link1', 'link2'], filter= ['1=1'])



