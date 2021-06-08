const { ApolloServer }　= require('apollo-server');
const { PrismaClient } = require('@prisma/client')
const fs = require('fs');
const path = require('path');
const prisma = new PrismaClient()

const resolvers = {
    Query: {
        info: () => `This is the API of a Hackernews Clone`,
        feed: async (parent, args, context) => {
            return await context.prisma.link.findMany()
        }
    },
    Link: {
        id: (parent) => parent.id,
        description: (parent) => parent.description,
        url: (parent) => parent.url,
    },
    Mutation: {
        post: (parent, args, context, info) => {
            const newLink =  context.prisma.link.create({
                data: {
                    description: args.description,
                    url: args.url,
                }
            })
            return newLink
        }
    }
}

const server = new ApolloServer({
    typeDefs: fs.readFileSync(
      path.join(__dirname, 'schema.graphql'),
      'utf8'
    ),
    resolvers,
    context: {
        prisma,
    }
  })

server.listen().then(({url}) => console.log(`Server is running on ${url}`))