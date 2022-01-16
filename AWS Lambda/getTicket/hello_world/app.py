import json


def lambda_handler(event, context):
    #print(event)
    student_scores = {"Cassio" : 100, "Victoria" : 100, "Garfinho" : 90 }
    score_list = []
    for name in event:
        score_list.append(student_scores[name])
    return score_list
