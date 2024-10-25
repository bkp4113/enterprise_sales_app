# MSK Topic & Group Creation

For demonstration purpose how to create topics and group in MSK serverless and could be reused for MSK server based as well. Alternatively can be created via the UI as well but may not be version controlled.

## Pre Requirements
- Install kafka on mac
  - `brew install kafka`
  - `curl https://github.com/aws/aws-msk-iam-auth/releases#:~:text=4-,aws%2Dmsk%2Diam%2Dauth%2D2.1.0%2Dall.jar,-14.2%20MB`

## Creating New Topic

- To create new topic follow below steps.
  - Add a new topic file by coping over existing .conf file specific to the env and make desired changes
  - Run `python3 msk_create_topic.py --topic <new_topic_name>`

## Assign Topic to Existing Group

- To assign new topic to existing group follow below steps.
  - Run `python3 msk_assign_group.py --topic <new_topic_names> --group_id test --bootst`

## Assign Topic to New Group

- To assign new topic to new group follow below steps.
  - Run `python msk_create_group.py --topic <new_topic_name>`